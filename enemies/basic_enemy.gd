class_name BasicEnemy
extends Enemy
## Basic Enemy Class
## Author: Lestavol
## Basic enemy scene and behaviors


func _ready() -> void:
	$DebugbugLabel.text = "HP: %d\nDMG: %d" % [health, damage]
