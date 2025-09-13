class_name PlayerRobotFactory
extends Node
## Player Factory Robot
## Author: Lestavol
## Factory class to create new robots based on given parameters


const ROBOT_SCENE: PackedScene = preload("uid://cetfvkhut1rm3")


static func new_robot(parameters: EntityParameters) -> PlayerRobot:
	var robot: PlayerRobot = ROBOT_SCENE.instantiate()
	robot.parameters = parameters
	
	return robot
