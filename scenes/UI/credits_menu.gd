extends Control
@onready var back_button = $CloseButton


func _on_close_button_pressed() -> void:
	Audio.play_random("sfx_ui_click")
	hide()
