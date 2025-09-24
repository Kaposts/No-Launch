class_name Enemy
extends Entity
## Basic Enemy Class
## Author: Lestavol
## Enemy scene and behaviors

@onready var sprite: Sprite2D = $Visuals/Sprite2D
@onready var hit_spark_light_player: AnimationPlayer = %HitSparkLightPlayer

#===================================================================================================
#region BUILT-IN FUNCTIONS

func _ready() -> void:
	super()
	
	sprite.texture = parameters.textures.pick_random()
	visuals.scale.x = -1.0
	
	%HitboxComponent.area_entered.connect(_on_hitbox_entered)

#endregion
#===================================================================================================
#region EVENT HANDLERS

func _on_hitbox_entered(_area: Area2D) -> void:
	hit_spark_light_player.play("sparking_light")

#endregion
