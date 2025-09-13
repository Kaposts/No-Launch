class_name KnockbackComponent
extends Node
## KnockbackComponent
##
## A component that provides the knockback functionality for a character whenever they are hit


@export var wall_bounce_component: WallBounceComponent

var _owner: CharacterBody2D

# TODO: Workaround for knocking back duration
var _is_active: bool = false
var _timer: float = 0.0
var _knock_duration: float


func _ready() -> void:
	assert(owner is CharacterBody2D, "Owner of knockback component is not a CharacterBody2D,
		from owner " + owner.name)
	_owner = owner


func _process(delta: float) -> void:
	if _is_active:
		_timer += delta
		if _timer > _knock_duration:
			wall_bounce_component.physics_active = false
			_timer = 0.0
			_knock_duration = 0.0
			_is_active = false
			wall_bounce_component.linear_velocity = Vector2.ZERO


func knockback(from: HitboxComponent,
			   distance: float = from.knockback_distance,
			   duration: float = from.knockback_duration) -> void:
	
	var direction: Vector2 = (_owner.global_position - from.global_position).normalized()
	#var impulse_magnitude: float = wall_bounce_component\
		#.calculate_impulse_magnitude_to_reach_distance_in_duration(distance, duration)
	var impulse_magnitude: float = from.knockback_force
	wall_bounce_component.physics_active = true
	wall_bounce_component.apply_central_impulse(direction * impulse_magnitude)
	
	_knock_duration = duration
	
	_is_active = true
	
	#await get_tree().create_timer(duration, false).timeout
	#wall_bounce_component.freeze = true


func knockback_tween(from: HitboxComponent,
					distance: float = from.knockback_distance,
					duration: float = from.knockback_duration,
					easing_mode: Tween.EaseType = Tween.EASE_OUT,
					transition_mode: Tween.TransitionType = Tween.TRANS_ELASTIC):
	var direction: Vector2 = (_owner.global_position - from.global_position).normalized()
	var end_position: Vector2 = _owner.global_position + direction * distance
	var tween = create_tween()
	
	tween.tween_property(_owner, "global_position", end_position, duration)\
	.set_ease(easing_mode)\
	.set_trans(transition_mode)
