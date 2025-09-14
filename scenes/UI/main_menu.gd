extends Node2D

@onready var options_menu = $Options_Menu/OptionsMenu 
@onready var main_menu_buttons = $TextureRect2/MainMenu_Buttons

func _ready():
	handle_connecting_signals()



func _on_options_button_pressed() -> void:
	options_menu.visible = true
	
func on_exit_options():
	options_menu.visible = false

func handle_connecting_signals():
	options_menu.exit_options_menu.connect(on_exit_options)
