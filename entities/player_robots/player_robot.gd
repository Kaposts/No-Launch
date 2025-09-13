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
	
	sprite.texture = parameters.texture
	
	$DebugbugLabel.text = "HP: %d\nDMG: %d" % [health_component.current_health, hitbox_component.damage]

#endregion
