class_name Entity
extends CharacterBody2D
## Entity Base Class
## Author: Lestavol
## base class that all entities will inherit from


@export var battling: bool = false:
	set(flag):
		battling = flag
		if navigator_component:
			navigator_component.enabled = battling
		if battling:
			battling_timer.start()
		else:
			battling_timer.stop()

@export var movement_speed: float = 150.0:
	set(value):
		movement_speed = value
		if navigator_component:
			navigator_component.movement_speed = movement_speed

@export_group("Targeting Settings")
@export var targets: Array[Node2D]:
	set(array):
		targets = array
		if navigator_component:
			navigator_component.targets = targets

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var navigator_component: NavigatorComponent = %NavigatorComponent
@onready var path_recalculation_timer: Timer = %PathRecalculationTimer
@onready var battling_timer: Timer = $Timers/BattlingTimer

@onready var attack_range: Area2D = %AttackRange
@onready var hitbox_component: HitboxComponent = %HitboxComponent
@onready var hurtbox_component: HurtboxComponent = %HurtboxComponent
@onready var health_component: HealthComponent = $HealthComponent
@onready var wall_bounce_component: WallBounceComponent = %WallBounceComponent


#===================================================================================================
#region BUILT-IN FUNCTIONS

func _ready() -> void:
	set_up_navigator()
	
	navigator_component.velocity_computed.connect(_on_navigator_component_velocity_computed)
	navigator_component.target_reached.connect(_on_navigator_component_target_reached)
	
	attack_range.body_entered.connect(_on_attack_range_entered)
	wall_bounce_component.sleeping_state_changed.connect(_on_wall_bounce_component_sleeping_state_changed)
	
	battling_timer.timeout.connect(_on_battling_timer_timeout)


#endregion
#===================================================================================================
#region NAVIGATOR FUNCTIONS

func set_up_navigator() -> void:
	navigator_component.enabled = battling
	navigator_component.current_agent_position = global_position
	navigator_component.movement_speed = movement_speed
	navigator_component.targets = targets


func start_navigating(target: Node2D = null) -> void:
	battling = true
	path_recalculation_timer.start()
	if target:
		targets.append(target)
	navigator_component.navigate_to_nearest_target_in_targets()


func stop_navigating(position_to_look_at: Vector2 = Vector2.ZERO) -> void:
	navigator_component.movement_speed = 0.0
	
	battling = false
	velocity = Vector2.ZERO
	navigator_component.stop()
	#animation_state_machine.travel("idle")
	path_recalculation_timer.stop()
	
	#if not position_to_look_at.is_equal_approx(Vector2.ZERO):
		#_direction = (position_to_look_at - global_position).normalized()
		#animation_tree.set(IDLE_BLEND_POSITION, _direction)


func _on_navigator_component_velocity_computed(safe_velocity: Vector2) -> void:
	if battling:
		velocity = safe_velocity
		move_and_slide()


func _on_navigator_component_target_reached() -> void:
	if targets.size() > 0:
		start_navigating()
	else:
		stop_navigating()


func _on_path_recalculation_timer_timeout() -> void:
	if battling and not navigator_component.is_target_reachable():
		_on_navigator_component_target_reached()

#endregion
#===================================================================================================
#region EVENT HANDLERS

func _on_attack_range_entered(body: Node2D) -> void:
	hitbox_component.rotation = position.angle_to(body.position)
	animation_player.play("attack")


func _on_battling_timer_timeout() -> void:
	if attack_range.has_overlapping_bodies():
		_on_attack_range_entered(attack_range.get_overlapping_bodies()[0])


func _on_wall_bounce_component_sleeping_state_changed() -> void:
	if wall_bounce_component.sleeping:
		start_navigating()


#endregion
#===================================================================================================
