extends Node2D

const LABELS: Dictionary[String, LabelSettings] = {
	"ally" : preload("uid://b0tfeq0xvfm4f"),
	"enemy" : preload("uid://ggkyhru2oryv"),
}

@onready var label: Label = $Label


func start(text: String, ally: bool = true):
	label.text = text
	
	if ally:
		label.label_settings = LABELS["ally"]
	else:
		label.label_settings = LABELS["enemy"]
	
	var tween = create_tween()
	tween.set_parallel()
	
	tween.tween_property(self, "global_position", (global_position + Vector2.UP * 16), .3)\
	.set_ease(Tween.EASE_OUT)\
	.set_trans(Tween.TRANS_CUBIC)
	tween.chain()
	
	tween.tween_property(self, "global_position", (global_position + Vector2.UP * 48), .5)\
	.set_ease(Tween.EASE_IN)\
	.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "scale", Vector2.ZERO, .5)\
	.set_ease(Tween.EASE_IN)\
	.set_trans(Tween.TRANS_CUBIC)
	tween.chain()
	
	tween.tween_callback(queue_free)
	
	var scale_tween = create_tween()
	scale_tween.tween_property(self, "scale", Vector2.ONE * 1.5, .15)\
	.set_ease(Tween.EASE_OUT)\
	.set_trans(Tween.TRANS_CUBIC)
	scale_tween.tween_property(self, "scale", Vector2.ONE, .15)\
	.set_ease(Tween.EASE_IN)\
	.set_trans(Tween.TRANS_CUBIC)
