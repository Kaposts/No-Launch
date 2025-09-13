class_name NavigatorComponent
extends NavigationAgent2D
## NavigationAgent2D component
## Author: Lestavol
## Provide the pathfinding functionality to characters.
## In owner node, needs to connect signal _on_velocity_computed and _on_target_reached.


## Movement speed of the navigator component is calculated every frame so a modifer needs to be set
## to get desired pixel/sec speed
const NAVIGATOR_SPEED_MODIFIER: float = 30.0
## Margin to consider nav link end points as reached
const NAV_LINK_END_MARGIN: float = 5.0

@export var enabled: bool = true

@export_group("Mandatory Settings")
@export var targets: Array[Node2D] = [] ## Actor will loop around these targets in order
@export var movement_speed: float:
	get:
		return movement_speed * NAVIGATOR_SPEED_MODIFIER
@export var current_agent_position: Vector2 = Vector2.ZERO

var current_target: Node2D: set = set_new_current_target

var _owner: Node2D
var _current_target_index: int = 0
var _on_nav_link : bool = false
var _nav_link_end_position : Vector2

@onready var update_timer: Timer = $UpdateTimer


func _ready():
	_owner = owner
	
	if enabled:
		update_timer.start()
	else:
		update_timer.stop()
	
	# Connect signals
	update_timer.timeout.connect(_on_update_timer_timeout)
	link_reached.connect(_on_navigation_link_reached)
	waypoint_reached.connect(_on_waypoint_reached)
	
	# On the first frame the NavigationServer map has not-
	# yet been synchronized; region data and any path query will return empty.
	# Wait for the NavigationServer synchronization by awaiting one frame in the script.
	# Make sure to not await during _ready.
	call_deferred("actor_setup")


func _physics_process(delta):
	if not enabled:
		return
	
	# Returns if we've reached the end of the path.
	if is_navigation_finished():
		return
	
	current_agent_position = _owner.global_position
	
	# Get the next path point from the navigation agent.
	var next_path_position: Vector2 = get_next_path_position()

	# Calculate the velocity to move towards the next path point.
	var new_velocity = current_agent_position.direction_to(next_path_position) * movement_speed * delta
	if avoidance_enabled:
		set_velocity(new_velocity)
	else:
		velocity_computed.emit(new_velocity)


## Setup the navigation agent.
func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame
	if enabled:
		start()
	else:
		stop()


## Navigate towards new_target. If not given, will navigate towards next target in targets array.
## Will stop if both are not defined
func start(new_target: Node2D = null) -> void:
	if new_target == null and targets.is_empty():
		printerr("Targets are not defined for " + owner.name + ". It will not move.")
		stop()
		return
	elif new_target:
		current_target = new_target
	else:
		current_target = targets.pick_random()
	
	enabled = true
	if update_timer.is_stopped():
		update_timer.start()


func stop() -> void:
	current_target = null


func pause() -> void:
	enabled = false
	update_timer.stop()


func set_new_current_target(new_target: Node2D) -> void:
	current_target = new_target
	if current_target == null:
		target_position = current_agent_position
		pause()
	else:
		target_position = current_target.global_position


func navigate_to_next_target_in_targets(reverse_path: bool = false) -> void:
	if targets.is_empty():
		stop()
		return
	
	if reverse_path:
		var new_index: int = _current_target_index - 1
		_current_target_index = new_index if new_index >= 0 else (targets.size() - 1)
	else:
		_current_target_index = (_current_target_index + 1) % targets.size()
	
	start()


## Only consider 2D coordinates space. Don't account for navigation distance and cost
func navigate_to_nearest_target_in_targets() -> void:
	if targets.is_empty():
		stop()
		return
	
	var distance: float = 0.0
	for i in targets.size():
		var current_distance: float = current_agent_position.distance_squared_to(targets[i].global_position)
		if is_equal_approx(distance, 0.0) or current_distance < distance:
			distance = current_distance
			_current_target_index = i
	
	start()


func get_current_path_length() -> float:
	return sqrt(get_current_path_length_squared())


func get_current_path_length_squared() -> float:
	if not is_target_reachable():
		return INF
	
	var path: PackedVector2Array = get_current_navigation_path()
	
	var result: float = 0.0
	
	for i in (path.size() - 1):
		result += path[i].distance_squared_to(path[i + 1])
	
	return result


## Called when the recalculation timer times out.
func _on_update_timer_timeout() -> void:
	if enabled and current_target != null and not current_target.is_queued_for_deletion():
		if not _on_nav_link:
			target_position = current_target.global_position
	else:
		target_position = current_agent_position


## Called when a navigation link has been reached.
func _on_navigation_link_reached(details : Dictionary) -> void:
	_on_nav_link = true # Temporarily disable recalculation to prevent jittering.
	_nav_link_end_position = details.link_exit_position


## Called when a waypoint has been reached.
func _on_waypoint_reached(details : Dictionary) -> void:
	# This next line checks the distance to the waypoint with a threshhold.
	# If the distance is less than NAV_LINK_END_MARGIN, then the waypoint has been reached.
	# This check produces unexpected results when comparing vectors directly.
	if details.position.distance_squared_to(_nav_link_end_position) < NAV_LINK_END_MARGIN ** 2.0:
		_on_nav_link = false
