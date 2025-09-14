extends Node2D

@onready var options_menu = $OptionsMenu 
@onready var main_menu_buttons = $TextureRect2/MainMenu_Buttons

func _ready():
	pass

func _on_options_button_pressed() -> void:
	options_menu.show()
	
func _on_start_pressed() -> void:
	await Global.transition()
	get_tree().change_scene_to_file("res://scenes/cabage.tscn")
	SignalBus.start_game.emit()

func _on_credits_pressed() -> void:
	pass # Replace with function body.

func _on_quit_pressed() -> void:
	get_tree().quit()
