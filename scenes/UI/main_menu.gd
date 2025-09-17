extends Node2D

@onready var options_menu = %OptionsMenu 
@onready var credits_menu = %CreditsMenu
@onready var main_menu_buttons = $TextureRect2/MainMenu_Buttons

@onready var start_button: TextureButton = %StartButton
@onready var credits_button: TextureButton = %CreditsButton
@onready var options_button: TextureButton = %OptionsButton
@onready var quit_button: TextureButton = %QuitButton
@onready var vignette: CanvasLayer = $Vignette


func _ready():
	MusicPlayer.switch_song(Enum.SONG_NAMES.TITLE_THEME, false, true)
	SceneManager.fade_in()
	vignette.hide()
	
	start_button.pressed.connect(_on_start_pressed)
	credits_button.pressed.connect(_on_credits_pressed)
	options_button.pressed.connect(_on_options_button_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	
	options_menu.visibility_changed.connect(_on_menu_visibility_changed)
	credits_menu.visibility_changed.connect(_on_menu_visibility_changed)


func _disable_all_buttons() -> void:
	start_button.disabled = true
	credits_button.disabled = true
	options_button.disabled = true
	quit_button.disabled = true


func _on_start_pressed() -> void:
	_disable_all_buttons()
	await Global.transition()
	get_tree().change_scene_to_file("res://scenes/Cutscenes/OpeningCutscene.tscn")


func _on_credits_pressed() -> void:
	credits_menu.show()


func _on_options_button_pressed() -> void:
	options_menu.show()


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_menu_visibility_changed() -> void:
	vignette.visible = credits_menu.visible or options_menu.visible
