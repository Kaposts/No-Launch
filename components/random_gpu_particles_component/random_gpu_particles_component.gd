class_name RandomGPUParticlesComponent
extends GPUParticles2D
## Random GPU Particles Component
## Author: Lestavol
## A component to emit particles chosen randomly from an array of textures

@export var textures: Array[Texture2D]


func emit() -> void:
	texture = textures.pick_random()
	emitting = true
