class_name PlayerRobot
extends Entity
## Player robot scene
## Author: Lestavol
## Player robots scenes represent the player's ally entities


@onready var sprite: Sprite2D = $Visuals/Sprite2D
@onready var hit_sfx_player: RandomAudioPlayer2D = %HitSFXPlayer
@onready var hurt_sfx_player: RandomAudioPlayer2D = %HurtSFXPlayer
@onready var spawn_sfx_player: RandomAudioPlayer2D = %SpawnSFXPlayer
@onready var buff_sfx_player: RandomAudioPlayer2D = %BuffSFXPlayer



#===================================================================================================
#region BUILT-IN FUNCTIONS

func _ready() -> void:
	super()
	
	var buff: PlayerBuffsResource = PlayerBuffs.get_buffs()
	health_component.max_health = parameters.health + buff.bonus_health
	hitbox_component.damage = parameters.damage + buff.bonus_damage
	movement_speed = parameters.speed + buff.bonus_speed
	sprite.texture = parameters.textures.pick_random()
	
	%HitboxComponent.area_entered.connect(_on_hitbox_entered)
	%HurtboxComponent.area_entered.connect(_on_hurtbox_entered)
	
	SignalBus.apply_buff.connect(_on_apply_buff)


func _on_apply_buff(data: ActivationResource):
	health_component.max_health = parameters.health
	hitbox_component.damage = parameters.damage
	
	print('applying buff')
	var buff: PlayerBuffsResource = PlayerBuffs.get_buffs()
	health_component.max_health += buff.bonus_health
	hitbox_component.damage += buff.bonus_damage
	
	buff_sfx_player.play_random()


func _on_hitbox_entered(_area: Area2D) -> void:
	#Audio.play_by_name(SFX.SFX_COMBAT_robot_attack)
	hit_sfx_player.play_random()


func _on_hurtbox_entered(_area: Area2D) -> void:
	#Audio.play_by_name(SFX.SFX_COMBAT_robot_hurt)
	hurt_sfx_player.play_random()


#endregion
