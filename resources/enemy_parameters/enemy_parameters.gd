class_name EnemyParameters
extends Resource
## Enemy Parameters
## Author: Lestavol
## Parameters to define enemy scene

@export var texture: Texture2D
@export_range(0, 10, 1, "or_greater") var health: int
@export_range(0, 10, 1, "or_greater") var damage: int
