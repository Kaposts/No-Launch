class_name Enemy
extends CharacterBody2D
## Enemy scene
## Author: Lestavol
## Enemy scenes represent the enemy entities

@export_range(0, 10, 1, "or_greater") var health: int
@export_range(0, 10, 1, "or_greater") var damage: int
