extends Control

func _ready():
	SignalBus.buff_applied.connect(_on_buff_applied)

func _on_buff_applied(sprites: Array):
	for texture in sprites:
		var sprite := Sprite2D.new()
		sprite.texture = texture
		sprite.position = position
		add_child(sprite)

		var tween := create_tween()
		tween.tween_property(sprite, "position:y", global_position.y - 200, 0.4).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tween.parallel().tween_property(sprite, "modulate", Color(1, 1, 1, 0), 0.4)

	# # Free sprite after tween completes
	# tween.finished.connect(func(): sprite.queue_free())
