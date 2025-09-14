class_name Enemy
extends Entity
## Basic Enemy Class
## Author: Lestavol
## Enemy scene and behaviors

@onready var sprite: Sprite2D = $Visuals/Sprite2D

#===================================================================================================
#region BUILT-IN FUNCTIONS

func _ready() -> void:
	super()
	
	sprite.texture = parameters.textures.pick_random()
	visuals.scale.x = -1.0
	
	$DebugbugLabel.text = "HP: %d\nDMG: %d" % [health_component.current_health, hitbox_component.damage]

#endregion
