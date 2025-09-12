class_name PlayerRobot
extends Entity
## Player robot scene
## Author: Lestavol
## Player robots scenes represent the player's ally entities


var parameters: PlayerRobotParameters


@onready var sprite: Sprite2D = $Visuals/Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

#===================================================================================================
#region BUILT-IN FUNCTIONS

func _ready() -> void:
	super()
	
	health = parameters.health
	damage = parameters.damage
	sprite.texture = parameters.texture
	
	$DebugbugLabel.text = "HP: %d\nDMG: %d" % [health, damage]

#endregion



func _on_attack_range_entered(body: Node2D) -> void:
	super(body)
	hitbox_component.rotation = position.angle_to(body.position)
	animation_player.play("attack")
