class_name EnemyFactory
extends Node
## Enemy Factory
## Author: Lestavol
## Factory class to create new enemy based on given parameters

enum Type{
	BASIC_INFANTRY,
}


const ENEMY_SCENES: Dictionary[Type, PackedScene] = {
	Type.BASIC_INFANTRY : preload("uid://bfbqdu1nyshr4"),
}


static func new_enemy(type: Type) -> Enemy:
	var enemy: Enemy = ENEMY_SCENES[type].instantiate()
	
	return enemy
