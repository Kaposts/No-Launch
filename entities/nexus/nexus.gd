class_name Nexus
extends Area2D
## Nexus Area2D class
## Author: Lestavol
## Home Base for each faction

@export var health: int = 20
@export var can_destroy_entity: bool = false:
	set(flag):
		can_destroy_entity = flag
		collider.disabled = !can_destroy_entity

@onready var debug_label: Label = $DebugLabel
@onready var collider: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	update_health()
	SignalBus.heal_nexus.connect(_on_heal_nexus)


func update_health() -> void:
	debug_label.text = "HP: %2d" % health



func _on_body_entered(body: Node2D) -> void:
	var damage = 1
	if RoundEffect.nexus_takes_double_damage:
		damage = 2
	health -= damage
	update_health()
	body.health_component.damage(1000)


func _on_heal_nexus(value: int):
	health += value
	update_health()
