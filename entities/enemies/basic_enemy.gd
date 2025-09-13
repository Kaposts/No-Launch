class_name BasicEnemy
extends Enemy
## Basic Enemy Class
## Author: Lestavol
## Basic enemy scene and behaviors

@export var enemy_hp: int = 6
@export var enemy_damage: int = 1


#===================================================================================================
#region BUILT-IN FUNCTIONS

func _ready() -> void:
	super()
	
	health_component.max_health = enemy_hp
	hitbox_component.damage = enemy_damage
	
	$DebugbugLabel.text = "HP: %d\nDMG: %d" % [health_component.current_health, hitbox_component.damage]

#endregion
#===================================================================================================
#region EVENT HANDLERS

func _on_attack_range_entered(body: Node2D) -> void:
	super(body)
	hitbox_component.rotation = position.angle_to(body.position)
	animation_player.play("attack")

#endregion
#===================================================================================================
