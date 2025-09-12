class_name HurtboxComponent
extends Area2D
## Hurtbox Component
##
## Area2D node that provides functionality of being hurt for characters

signal hit(hitbox_component: HitboxComponent)

@export var invicibility_duration: float = 0.2
@export var health_component: Node
@export var navigator_component: NavigatorComponent
@export var knockback_component: KnockbackComponent
@export var hit_flash_component: HitFlashComponent
@export var hitstop_component: HitstopComponent

@onready var invicibility_timer: Timer = $InvicibilityTimer


func _ready() -> void:
	assert(health_component != null, "Health Component is null, from Hurtbox Component of " + owner.name)
	
	area_entered.connect(_on_area_entered)


func _on_area_entered(hitbox_component: HitboxComponent) -> void:
	if not invicibility_timer.is_stopped():
		return
	
	invicibility_timer.wait_time = invicibility_duration + hitbox_component.hitstop_duration
	invicibility_timer.start()
	
	hit.emit(hitbox_component)
	health_component.damage(hitbox_component.damage)
	hit_flash_component.flash(invicibility_duration)
	navigator_component.pause()
	hitstop_component.freeze_frame(hitbox_component.hitstop_duration)
	
	await get_tree().create_timer(hitbox_component.hitstop_duration, false).timeout
	
	# Need to check for previously freed physics objects
	if hitbox_component != null:
		navigator_component.pause()
		#knockback_component.knockback(hitbox_component)
		knockback_component.knockback_tween(hitbox_component)
