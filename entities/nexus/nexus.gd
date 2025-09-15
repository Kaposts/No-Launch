class_name Nexus
extends Area2D
## Nexus Area2D class
## Author: Lestavol
## Home Base for each faction

signal destroyed

@export var health: int = 30
@export var can_destroy_entity: bool = false:
	set(flag):
		can_destroy_entity = flag
		collider.disabled = !can_destroy_entity

@export var ally: bool = true

var _dying: bool = false

@onready var debug_label: Label = $DebugLabel
@onready var collider: CollisionShape2D = $CollisionShape2D
@onready var hurt_sfx_player: RandomAudioPlayer = $HurtSFXPlayer
@onready var ally_core: Node2D = $AllyCore
@onready var enemy_core: Node2D = $EnemyCore
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	update_health()
	
	ally_core.visible = ally
	enemy_core.visible = !ally
	
	SignalBus.heal_nexus.connect(_on_heal_nexus)


func update_health() -> void:
	debug_label.text = "HP: %2d" % health


func _on_body_entered(body: Node2D) -> void:
	var damage = 1
	if RoundEffect.nexus_takes_double_damage:
		damage = 2
	health -= damage
	update_health()
	body.health_component.damage(1000)
	
	hurt_sfx_player.play_random()
	
	if health <= 0:
		call_deferred("die")


func die():
	if _dying:
		return
	else:
		_dying = true
	
	destroyed.emit()
	
	if ally:
		animation_player.play("destroy_ally")
		await animation_player.animation_finished
		SignalBus.player_lost.emit()
		Global.game_is_paused = true
	else:
		animation_player.play("destroy_enemy")
		await animation_player.animation_finished
		get_tree().change_scene_to_file("res://scenes/Cutscenes/EndingCutScene.tscn")


func _on_heal_nexus(value: int):
	health += value
	update_health()
