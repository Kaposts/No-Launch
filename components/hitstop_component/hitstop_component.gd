class_name HitstopComponent
extends Node
## Hitstop Component
##
## Component node that provide hitstop animation functionality for a game object
## that have their states managed with an animation tree node

## The animation must be set up in a AnimationNodeBlendTree in a Animation Tree with the Timescale 
## property set to be blended. The Hitstop Component expects the animations to be set up prior for 
## it to work properly.


@export var animation_tree: AnimationTree


## Direct path to TimeScale property of a AnimationBlendTree that expects to be frame frozen
@export var time_scale_property_path: String = "parameters/TimeScale/scale"

## 0.0 completely freezes the animation. 1.0 plays the animation normally.
@export_range(0.0, 1.0, 0.001) var time_scale_percent: float = 0.0


func freeze_frame(duration: float) -> void:
	pass
	#animation_tree.set(time_scale_property_path, time_scale_percent)
	#await get_tree().create_timer(duration, false).timeout
	#animation_tree.set(time_scale_property_path, 1.0)
