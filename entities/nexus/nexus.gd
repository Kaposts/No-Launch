class_name Nexus
extends Area2D
## Nexus Area2D class
## Author: Lestavol
## Home Base for each faction

signal destroyed

const DAMAGE_ANIMATION_DURATION: float = 0.3

@export var health: int = 30
@export var can_destroy_entity: bool = false:
	set(flag):
		can_destroy_entity = flag
		collider.disabled = !can_destroy_entity

@export var ally: bool = true

var dying: bool = false

@onready var health_label: Label = $HealthLabel
@onready var collider: CollisionShape2D = $CollisionShape2D
@onready var ally_core: Node2D = $AllyCore
@onready var enemy_core: Node2D = $EnemyCore
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hurt_sfx_player: RandomAudioPlayer = %HurtSFXPlayer
@onready var victory_sfx_player: AudioStreamPlayer = $SFX/VictorySFXPlayer
@onready var defeat_sfx_player: AudioStreamPlayer = $SFX/DefeatSFXPlayer
@onready var ally_shaker_component: ShakerComponent2D = %AllyShakerComponent
@onready var enemy_shaker_component: ShakerComponent2D = %EnemyShakerComponent
@onready var ally_hit_flash_component: HitFlashComponent = %AllyHitFlashComponent
@onready var enemy_hit_flash_component: HitFlashComponent = %EnemyHitFlashComponent


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	update_health()
	
	ally_core.visible = ally
	enemy_core.visible = !ally
	
	ally_shaker_component.duration = DAMAGE_ANIMATION_DURATION
	enemy_shaker_component.duration = DAMAGE_ANIMATION_DURATION
	
	SignalBus.heal_nexus.connect(_on_heal_nexus)


func update_health() -> void:
	health_label.text = "%2d" % health


func _on_body_entered(body: Node2D) -> void:
	var damage = 1
	if RoundEffect.nexus_takes_double_damage:
		damage = 2
	health -= damage
	update_health()
	body.health_component.damage(1000)
	
	hurt_sfx_player.play_random()
	
	if ally:
		ally_shaker_component.play_shake()
		ally_hit_flash_component.flash(DAMAGE_ANIMATION_DURATION)
	else:
		enemy_shaker_component.play_shake()
		enemy_hit_flash_component.flash(DAMAGE_ANIMATION_DURATION)
	
	
	if health <= 0:
		call_deferred("die")


func die():
	if dying:
		return
	else:
		dying = true
	
	destroyed.emit()
	
	if ally:
		animation_player.play("destroy_ally")
		await animation_player.animation_finished
		defeat_sfx_player.play()
		SignalBus.player_lost.emit()
		Global.game_is_paused = true
	else:
		animation_player.play("destroy_enemy")
		await animation_player.animation_finished
		get_tree().change_scene_to_file("res://scenes/Cutscenes/EndingCutScene.tscn")


func _on_heal_nexus(value: int):
	health += value
	update_health()
