class_name DeathComponent
extends Node2D

@export var health_component: HealthComponent
@export var sprite: Sprite2D


func _ready():
	$GPUParticles2D.texture = sprite.texture
	health_component.died.connect(on_died)


func on_died():
	if owner == null || not owner is Node2D || get_tree() == null:
		return
	var spawn_position = owner.global_position
	
	var death_layer: Node2D = get_tree().get_first_node_in_group("death_layer")
	get_parent().remove_child(self)
	death_layer.add_child(self)
	
	global_position = spawn_position
	$AnimationPlayer.play("default")
	Audio.play_random("sfx_death_component_death_")
	
