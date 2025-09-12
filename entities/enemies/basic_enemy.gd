class_name BasicEnemy
extends Enemy
## Basic Enemy Class
## Author: Lestavol
## Basic enemy scene and behaviors

#===================================================================================================
#region BUILT-IN FUNCTIONS

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	super()
	
	$DebugbugLabel.text = "HP: %d\nDMG: %d" % [health, damage]

#endregion



func _on_attack_range_entered(body: Node2D) -> void:
	super(body)
	hitbox_component.rotation = position.angle_to(body.position)
	animation_player.play("attack")
