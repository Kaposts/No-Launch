class_name HitFlashComponent
extends Node
## Hit Flash Component
##
## A node component that adds a flashing effect on a character when they get hit


@export var sprite_group: Array[Sprite2D]
@export var hit_flash_material: ShaderMaterial

var hit_flash_tween: Tween


func _ready():
	for sprite in sprite_group:
		sprite.material = hit_flash_material


func flash(duration: float):
	# Kill the tween if it exist in case multiple hits are registered in a short amount of time
	if hit_flash_tween != null && hit_flash_tween.is_running():
		hit_flash_tween.kill()
	
	for sprite in sprite_group:
		# Set the shader material lerp percent to 1.0
		(sprite.material as ShaderMaterial).set_shader_parameter("lerp_percent", 1.0)
		
		hit_flash_tween = create_tween()
		
		# Tween lerp precent to 0.0 over Hurtbox Component invicibility duration
		hit_flash_tween.tween_property(sprite.material, "shader_parameter/lerp_percent", 0.0, duration)\
		.set_ease(Tween.EASE_IN)\
		.set_trans(Tween.TRANS_CUBIC)
