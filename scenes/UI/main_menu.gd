extends Node2D

@onready var options_menu = $OptionsMenu 
@onready var credits_menu = $CreditsMenu
@onready var main_menu_buttons = $TextureRect2/MainMenu_Buttons

func _ready():
	MusicPlayer.switch_song(MusicPlayer.SongNames.TITLE_THEME, false, true)
	await Global.transition()

func _on_options_button_pressed() -> void:
	Audio.play_random("sfx_ui_click")
	options_menu.show()
	
func _on_start_pressed() -> void:
	Audio.play_random("sfx_ui_click")
	await Global.transition()
	get_tree().change_scene_to_file("res://scenes/Cutscenes/OpeningCutscene.tscn")

func _on_credits_pressed() -> void:
	Audio.play_random("sfx_ui_click")
	credits_menu.show()

func _on_quit_pressed() -> void:
	Audio.play_random("sfx_ui_click")
	get_tree().quit()
