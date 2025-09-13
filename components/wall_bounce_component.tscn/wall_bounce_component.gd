class_name WallBounceComponent
extends RigidBody2D
## Wall Bounce Component
##
## A RigidBody2D node working in tandem with Knockback Component to provides knockback physics that
## detects and slide against walls. WallBounceComponent must be a child of a plain Node (not a Node2D
## to simulate positions correctly. Best to add it as a child of the Knockback Component.

## When true, the owner entity follow the wall bounce component, and vice versa
@export var physics_active: bool = false


func _physics_process(_delta: float) -> void:
	if physics_active:
		owner.global_position = global_position
	else:
		global_position = owner.global_position


func calculate_impulse_magnitude_to_reach_distance_in_duration(distance: float, duration: float) -> float:
	var speed: float
	
	if linear_damp == 0.0:
		speed = distance / duration
	else:
		var decay_factor: float = 1.0 - exp(-linear_damp * duration)
		speed = distance / decay_factor * linear_damp

	return speed * mass
