extends CanvasLayer

func _on_button_pressed() -> void:
	await Global.transition()

func _on_button_2_pressed() -> void:
	Dialogic.start("timeline")
