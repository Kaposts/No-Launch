class_name NavigatorFactory
extends Node
## Navigator Factory helper class
## Author: Lestavol
## An interface to help instantiate a Navigator Component.
## After instancing, the created node must be added to a 2D owner to work properly

const NAVIGATOR_SCENE: PackedScene = preload(Global.SCENE_PATHS.navigator_component)


static func new_navigator(current_position: Vector2, target: Node2D = null) -> NavigatorComponent:
	var navigator: NavigatorComponent = NAVIGATOR_SCENE.instantiate()
	navigator.current_agent_position = current_position
	navigator.target = target
	
	if target != null:
		navigator.enabled = true
	else:
		navigator.enabled = false
	
	return navigator
