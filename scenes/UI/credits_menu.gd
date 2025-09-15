extends Control
@onready var close_button = $CloseButton


func _ready() -> void:
	close_button.pressed.connect(_on_close_button_pressed)


func _on_close_button_pressed() -> void:
	hide()
