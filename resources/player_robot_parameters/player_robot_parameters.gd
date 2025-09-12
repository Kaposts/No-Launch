class_name PlayerRobotParameters
extends Resource
## Player Robot Parameters
## Author: Lestavol
## Parameters to define player robot scene

@export var texture: Texture2D
@export_range(0, 10, 1, "or_greater") var health: int
@export_range(0, 10, 1, "or_greater") var damage: int
