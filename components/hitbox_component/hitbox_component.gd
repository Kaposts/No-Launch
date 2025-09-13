class_name HitboxComponent
extends Area2D
## Hitbox Component
##
## Holds data for a hitbox of attack area2D component

signal hit_connected(hurtbox_component: HurtboxComponent)

@export var damage: float = 0.0
#@export var sfx_player: RandomAudioPlayer2D

@export_group("Attack Knockback Parameters")
@export var knockback_distance: float = 60.0
@export var knockback_force: float = 360.0
@export var knockback_duration: float = 0.2

@export_group("Attack Hitstop Parameters")
@export_range(0.0, 10.0, 0.001) var hitstop_duration: float = 0.12
@export var hitstop_component: HitstopComponent

@export var navigator_component: NavigatorComponent


func _ready() -> void:
	area_entered.connect(_on_area_entered)


func _on_area_entered(hurtbox_component: HurtboxComponent) -> void:
	hit_connected.emit(hurtbox_component)
	#sfx_player.play_random()
	
	# TODO: Placeholder for if character don't use AnimationTree to hit stop
	if hitstop_component == null:
		return
	
	hitstop_component.freeze_frame(hitstop_duration)
