extends CharacterBody2D
class_name Minion

const IDLE: String = "idle" 
const BATTLE: String = "battle" 
const END: String = "end" 

@export var target_group: String
@export var target_nexus: String

@export var speed: int = 100
@export var attack_range: float = 10
@export var damage: float = 10
@export var health: float = 10
@export var attack_cooldown: float = 1

@export var data: EntityParameters

@onready var health_component: = $Components/HealthComponent

func _ready():
	health = data.health
	damage = data.damage
	speed = data.speed
	attack_cooldown = data.attack_cooldown
	health_component.max_health = data.health
