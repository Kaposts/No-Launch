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
	
	health_component.max_health = parameters.health
	hitbox_component.damage = parameters.damage
	sprite.texture = parameters.texture
	
	$DebugbugLabel.text = "HP: %d\nDMG: %d" % [health_component.current_health, hitbox_component.damage]

#endregion
