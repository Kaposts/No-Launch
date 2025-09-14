class_name EntityParameters
extends Resource
## Entity Parameters
## Author: Lestavol
## Parameters to define an entity scene

@export var textures: Array[Texture2D]
@export_range(0, 10, 1, "or_greater") var health: int
@export_range(0, 10, 1, "or_greater") var damage: int
@export_range(0.0, 200.0, 0.1, "or_greater") var speed: float
