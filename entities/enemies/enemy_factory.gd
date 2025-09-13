class_name EnemyFactory
extends Node
## Enemy Factory
## Author: Lestavol
## Factory class to create new enemy based on given parameters


const ENEMY_SCENE: PackedScene = preload("uid://bfbqdu1nyshr4")


static func new_enemy(parameters: EntityParameters) -> Enemy:
	var enemy: Enemy = ENEMY_SCENE.instantiate()
	enemy.parameters = parameters
	
	return enemy
