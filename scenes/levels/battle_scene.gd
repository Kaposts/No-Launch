extends Node2D

const RANDOM_OFFSET: float = 50.0
const PLAYER_ROBOT_PARAMETERS_PATH: String = "res://resources/player_robot_parameters/"
const ENEMY_PARAMETERS_PATH: String = "res://resources/enemy_parameters/"

@onready var robot_button: Button = %RobotButton
@onready var enemy_button: Button = %EnemyButton
@onready var start_battle_button: Button = %StartBattleButton
@onready var player_marker: Marker2D = %PlayerMarker
@onready var enemy_marker: Marker2D = %EnemyMarker
@onready var player_layer: Node2D = $PlayerLayer
@onready var enemy_layer: Node2D = $EnemyLayer
@onready var player_nexus: Nexus = $PlayerNexus
@onready var enemy_nexus: Nexus = $EnemyNexus


var player_robot_types: Array[EntityParameters] = []
var enemy_types: Array[EntityParameters] = []
var player_robots: Array[Node2D] = []
var enemies: Array[Node2D] = []

#===================================================================================================
#region BUILT-IN FUNCTIONS

func _ready() -> void:
	robot_button.pressed.connect(_on_robot_button_pressed)
	enemy_button.pressed.connect(_on_enemy_button_pressed)
	start_battle_button.pressed.connect(_on_start_battle_button_pressed)

	SignalBus.spawn_player.connect(_on_robot_button_pressed)
	
	_load_player_available_robot_types()
	_load_enemy_types()
	
	MusicPlayer.switch_song(MusicPlayer.SongNames.PRE_BATTLE, false, true)

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
	
	enemies.clear()
	for child in enemy_layer.get_children():
		if child not in excluded_entities:
			enemies.append(child as Node2D)
	
	SignalBus.entities_array_updated.emit()

#endregion
#===================================================================================================
#region EVENT HANDLERS

func _on_robot_button_pressed() -> void:
	var new_robot: PlayerRobot = PlayerRobotFactory.new_robot(player_robot_types.pick_random())
	player_layer.add_child(new_robot)
	new_robot.position = Vector2(player_marker.position.x + randf_range(-RANDOM_OFFSET, RANDOM_OFFSET),
								 player_marker.position.y + randf_range(-RANDOM_OFFSET, RANDOM_OFFSET))
	new_robot.health_component.died.connect(_on_entity_died.bind(new_robot))


func _on_enemy_button_pressed() -> void:
	var new_enemy: Enemy = EnemyFactory.new_enemy(enemy_types.pick_random())
	enemy_layer.add_child(new_enemy)
	new_enemy.position = Vector2(enemy_marker.position.x + randf_range(-RANDOM_OFFSET, RANDOM_OFFSET),
								 enemy_marker.position.y + randf_range(-RANDOM_OFFSET, RANDOM_OFFSET))
	new_enemy.health_component.died.connect(_on_entity_died.bind(new_enemy))


func _on_start_battle_button_pressed() -> void:
	_set_valid_entities()
	
	if not player_robots.is_empty() and not enemies.is_empty():
		for player_robot in player_robots:
			player_robot = player_robot as PlayerRobot
			player_robot.targets = enemies
			player_robot.start_navigating(enemies.pick_random())
		
		for enemy in enemies:
			enemy = enemy as Enemy
			enemy.targets = player_robots
			enemy.start_navigating(player_robots.pick_random())


func _on_entity_died(entity: Entity) -> void:
	_set_valid_entities([entity])
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

#endregion
#===================================================================================================
