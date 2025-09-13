extends Node2D

const RANDOM_OFFSET: float = 50.0
const PLAYER_ROBOT_PARAMETERS_PATH: String = "res://resources/player_robot_parameters/"

@onready var robot_button: Button = %RobotButton
@onready var enemy_button: Button = %EnemyButton
@onready var start_battle_button: Button = %StartBattleButton
@onready var player_marker: Marker2D = %PlayerMarker
@onready var enemy_marker: Marker2D = %EnemyMarker
@onready var player_layer: Node2D = $PlayerLayer
@onready var enemy_layer: Node2D = $EnemyLayer


var player_robot_types: Array[PlayerRobotParameters] = []


func _ready() -> void:
	robot_button.pressed.connect(_on_robot_button_pressed)
	enemy_button.pressed.connect(_on_enemy_button_pressed)
	start_battle_button.pressed.connect(_on_start_battle_button_pressed)
	
	_load_player_available_robot_types()


func _load_player_available_robot_types() -> void:
	var directory_path: String = PLAYER_ROBOT_PARAMETERS_PATH
	
	# Get all resource files in the given dirrectory
	var resources: PackedStringArray = ResourceLoader.list_directory(directory_path)
	
	for resource_file in resources:
		if resource_file.ends_with(".gd"):
			continue
		
		# Load the resource and then sort it by rarity into a dictionary
		var param: PlayerRobotParameters = load(directory_path + resource_file)
		player_robot_types.append(param)

func _on_robot_button_pressed() -> void:
	var new_robot: PlayerRobot = PlayerRobotFactory.new_robot(player_robot_types.pick_random())
	player_layer.add_child(new_robot)
	new_robot.position = Vector2(player_marker.position.x + randf_range(-RANDOM_OFFSET, RANDOM_OFFSET),
								 player_marker.position.y + randf_range(-RANDOM_OFFSET, RANDOM_OFFSET))


func _on_enemy_button_pressed() -> void:
	var new_enemy: Enemy = EnemyFactory.new_enemy(EnemyFactory.Type.values().pick_random())
	enemy_layer.add_child(new_enemy)
	new_enemy.position = Vector2(enemy_marker.position.x + randf_range(-RANDOM_OFFSET, RANDOM_OFFSET),
								 enemy_marker.position.y + randf_range(-RANDOM_OFFSET, RANDOM_OFFSET))


func _on_start_battle_button_pressed() -> void:
	var player_robots: Array = player_layer.get_children()
	var enemies: Array = enemy_layer.get_children()
	
	for player_robot in player_robots:
		player_robot = player_robot as PlayerRobot
		player_robot.start_navigating(enemies.pick_random() as Node2D)
	
	for enemy in enemies:
		enemy = enemy as Enemy
		enemy.start_navigating(player_robots.pick_random() as Node2D)
