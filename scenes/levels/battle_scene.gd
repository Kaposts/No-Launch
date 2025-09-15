extends Node2D

const POSITION_OFFSET: float = 50.0
const APPEAR_TIMING_OFFSET: float = 0.5
const PLAYER_ROBOT_PARAMETERS_PATH: String = "res://resources/player_robot_parameters/"
const ENEMY_PARAMETERS_PATH: String = "res://resources/enemy_parameters/"


@export_group("Battle Settings")
@export var min_robot_count: int = 3
@export var max_robot_count: int = 5
@export var min_enemy_count: int = 5
@export var max_enemy_count: int = 10

@onready var player_marker: Marker2D = %PlayerMarker
@onready var enemy_marker: Marker2D = %EnemyMarker
@onready var player_layer: Node2D = $PlayerLayer
@onready var enemy_layer: Node2D = $EnemyLayer
@onready var player_nexus: Nexus = $PlayerNexus
@onready var enemy_nexus: Nexus = $EnemyNexus
@onready var reset_navigation_timer: Timer = $ResetNavigationTimer


var player_robot_types: Array[EntityParameters] = []
var enemy_types: Array[EntityParameters] = []
var player_robots: Array[Node2D] = []
var enemies: Array[Node2D] = []

#===================================================================================================
#region BUILT-IN FUNCTIONS

func _ready() -> void:
	SignalBus.spawn_player.connect(spawn_robot)
	SignalBus.start_round.connect(start_battle)
	
	reset_navigation_timer.timeout.connect(_on_reset_navigation_timer_timeout)
	
	_load_player_available_robot_types()
	_load_enemy_types()
	
	MusicPlayer.switch_song(MusicPlayer.SongNames.PRE_BATTLE, false, true)
	
	await get_tree().create_timer(0.5, false).timeout
	prep_battle()

#endregion
#===================================================================================================
#region PUBLIC FUNCTIONS

func spawn_robot() -> void:
	var new_robot: PlayerRobot = PlayerRobotFactory.new_robot(player_robot_types.pick_random())
	new_robot.timing_offset = randf_range(0.0, APPEAR_TIMING_OFFSET)
	player_layer.add_child(new_robot)
	new_robot.position = Vector2(player_marker.position.x + randf_range(-POSITION_OFFSET, POSITION_OFFSET),
								 player_marker.position.y + randf_range(-POSITION_OFFSET, POSITION_OFFSET))
	new_robot.health_component.died.connect(_on_entity_died.bind(new_robot))


func spawn_robots(how_many: int) -> void:
	if Global.game_is_paused: return
	for i in how_many:
		spawn_robot()


func spawn_enemy() -> void:
	var new_enemy: Enemy = EnemyFactory.new_enemy(enemy_types.pick_random())
	new_enemy.timing_offset = randf_range(0.0, APPEAR_TIMING_OFFSET)
	enemy_layer.add_child(new_enemy)
	new_enemy.position = Vector2(enemy_marker.position.x + randf_range(-POSITION_OFFSET, POSITION_OFFSET),
								 enemy_marker.position.y + randf_range(-POSITION_OFFSET, POSITION_OFFSET))
	new_enemy.health_component.died.connect(_on_entity_died.bind(new_enemy))


func spawn_enemies(how_many: int) -> void:
	if Global.game_is_paused: return
	for i in how_many:
		spawn_enemy()


func prep_battle(robot_count: int = randi_range(min_robot_count, max_robot_count),
				 enemy_count: int = randi_range(min_enemy_count, max_enemy_count)) -> void:
	
	reset_navigation_timer.stop()
	
	var tween: Tween = get_tree().create_tween()
	tween.set_parallel()
	tween.tween_callback(spawn_robots.bind(robot_count))
	tween.tween_callback(spawn_enemies.bind(enemy_count))
	
	player_nexus.can_destroy_entity = false
	enemy_nexus.can_destroy_entity = false
	
	MusicPlayer.switch_song(MusicPlayer.SongNames.PRE_BATTLE)


func start_battle() -> void:
	_set_valid_entities()
	
	if not player_robots.is_empty() and not enemies.is_empty():
		for player_robot in player_robots:
			if player_robot.is_queued_for_deletion():
				continue
			player_robot = player_robot as PlayerRobot
			player_robot.targets = enemies
			player_robot.start_navigating(enemies.pick_random())
		
		for enemy in enemies:
			if enemy.is_queued_for_deletion():
				continue
			enemy = enemy as Enemy
			enemy.targets = player_robots
			enemy.start_navigating(player_robots.pick_random())
	
	MusicPlayer.switch_song(MusicPlayer.SongNames.MAIN_BATTLE, false)
	reset_navigation_timer.start()

#endregion
#===================================================================================================
#region PRIVATE FUNCTIONS

func _load_player_available_robot_types() -> void:
	var directory_path: String = PLAYER_ROBOT_PARAMETERS_PATH
	
	# Get all resource files in the given dirrectory
	var resources: PackedStringArray = ResourceLoader.list_directory(directory_path)
	
	for resource_file in resources:
		if resource_file.ends_with(".gd"):
			continue
		
		var param: EntityParameters = load(directory_path + resource_file)
		player_robot_types.append(param)


func _load_enemy_types() -> void:
	var directory_path: String = ENEMY_PARAMETERS_PATH
	
	# Get all resource files in the given dirrectory
	var resources: PackedStringArray = ResourceLoader.list_directory(directory_path)
	
	for resource_file in resources:
		if resource_file.ends_with(".gd"):
			continue
		
		var param: EntityParameters = load(directory_path + resource_file)
		enemy_types.append(param)


func _set_valid_entities(excluded_entities: Array[Entity] = []) -> void:
	player_robots.clear()
	for child in player_layer.get_children():
		if child not in excluded_entities:
			player_robots.append(child as Node2D)
	if player_robots.is_empty():
		player_nexus.can_destroy_entity = true
	
	enemies.clear()
	for child in enemy_layer.get_children():
		if child not in excluded_entities:
			enemies.append(child as Node2D)
	if enemies.is_empty():
		enemy_nexus.can_destroy_entity = true
	
	SignalBus.entities_array_updated.emit()


func _is_battle_ended() -> bool:
	return enemies.is_empty() and player_robots.is_empty()

#endregion
#===================================================================================================
#region EVENT HANDLERS

func _on_entity_died(entity: Entity) -> void:
	_set_valid_entities([entity])
	reset_navigation_timer.start()
	
	# Check if battle is finished and start a new round
	if _is_battle_ended():
		SignalBus.end_round.emit()
		Audio.play_by_name(SFX.SFX_SYSTEM_end_turn)
		prep_battle()
		return
	
	# If last entity of a faction dies, redirect all survivors to the opposing nexus
	if enemies.is_empty():
		for player_robot in player_robots:
			player_robot = player_robot as PlayerRobot
			player_robot.start_navigating(enemy_nexus)
		return
	elif player_robots.is_empty():
		for enemy in enemies:
			enemy = enemy as Enemy
			enemy.start_navigating(player_nexus)
		return
	
	# Reset navigation for opposing faction when an entity dies
	if entity is Enemy:
		for player_robot in player_robots:
			player_robot = player_robot as PlayerRobot
			if player_robot.navigator_component.current_target == entity:
				player_robot.start_navigating()
	elif entity is PlayerRobot:
		for enemy in enemies:
			enemy = enemy as Enemy
			if enemy.navigator_component.current_target == entity:
				enemy.start_navigating()


func _on_reset_navigation_timer_timeout() -> void:
	# Reset navigation for all entities when a certain amount of time has passed but no death occurs
	start_battle()

#endregion
#===================================================================================================
