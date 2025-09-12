class_name PlayerRobot
extends CharacterBody2D
## Player robot scene
## Author: Lestavol
## Player robots scenes represent the player's ally entities


var parameters: PlayerRobotParameters

var health: int
var damage: int

@onready var sprite: Sprite2D = $Visuals/Sprite2D


func _ready() -> void:
	health = parameters.health
	damage = parameters.damage
	sprite.texture = parameters.texture
	
	$DebugbugLabel.text = "HP: %d\nDMG: %d" % [health, damage]
