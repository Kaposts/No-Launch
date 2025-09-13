class_name PlayerRobot
extends Entity
## Player robot scene
## Author: Lestavol
## Player robots scenes represent the player's ally entities


var parameters: PlayerRobotParameters


@onready var sprite: Sprite2D = $Visuals/Sprite2D

#===================================================================================================
#region BUILT-IN FUNCTIONS

func _ready() -> void:
	super()
	
	var buff: PlayerBuffsResource = PlayerBuffs.get_buffs()
	health_component.max_health = parameters.health + buff.bonus_health
	hitbox_component.damage = parameters.damage + buff.bonus_damage
	sprite.texture = parameters.texture
	
	$DebugbugLabel.text = "HP: %d\nDMG: %d" % [health_component.current_health, hitbox_component.damage]

	SignalBus.apply_buff.connect(_on_apply_buff)

func _on_apply_buff(data: ActivationResource):
	var buff: PlayerBuffsResource = PlayerBuffs.get_buffs()
	health_component.max_health += buff.bonus_health
	hitbox_component.damage += buff.bonus_damage
	
#endregion
