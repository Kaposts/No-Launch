class_name PlayerRobot
extends Entity
## Player robot scene
## Author: Lestavol
## Player robots scenes represent the player's ally entities


@onready var sprite: Sprite2D = $Visuals/Sprite2D

#===================================================================================================
#region BUILT-IN FUNCTIONS

func _ready() -> void:
	super()
	
	var buff: PlayerBuffsResource = PlayerBuffs.get_buffs()
	health_component.max_health = parameters.health + buff.bonus_health
	hitbox_component.damage = parameters.damage + buff.bonus_damage
	movement_speed = parameters.speed + buff.bonus_speed
	sprite.texture = parameters.textures.pick_random()
	
	SignalBus.apply_buff.connect(_on_apply_buff)


func _on_apply_buff(data: ActivationResource):
	health_component.max_health = parameters.health
	hitbox_component.damage = parameters.damage

	print('applying buff')
	var buff: PlayerBuffsResource = PlayerBuffs.get_buffs()
	health_component.max_health += buff.bonus_health
	hitbox_component.damage += buff.bonus_damage
	
#endregion
