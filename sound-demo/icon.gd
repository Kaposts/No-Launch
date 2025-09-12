extends Node2D  # or KinematicBody2D / Area2D depending on your object

# Movement speed in pixels per second
@export var speed: float = 200.0
# How far to move from the original position
@export var distance: float = 300.0

var start_position: Vector2
var target_position: Vector2
var moving_right: bool = true

func _ready():
    start_position = position
    target_position = start_position + Vector2(distance, 0)

func _process(delta):
    if moving_right:
        position.x += speed * delta
        if position.x >= target_position.x:
            moving_right = false
    else:
        position.x -= speed * delta
        if position.x <= start_position.x:
            moving_right = true
