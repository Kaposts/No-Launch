extends CanvasLayer

func _on_button_pressed() -> void:
	await Global.transition()

func _on_button_2_pressed() -> void:
	Dialogic.start("timeline")

func _on_button_3_pressed() -> void:
	SFX.play_sfx(Sound.SFX_UI_BACK_001)
