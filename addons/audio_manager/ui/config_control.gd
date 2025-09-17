@tool
extends Control
class_name ConfigControl

var config: AudioManagerConfig

func _ready():
	config = ResourceLoader.load("res://addons/audio_manager/config/config.tres")
	$config_container/sfx_directory/btn.pressed.connect(_on_browse_pressed)
	$config_container/sfx_directory/FileDialog.dir_selected.connect(_on_dir_selected)
	$config_container/sfx_directory/input.text = config.sfx_directory
	$config_container/pitch_randomizer_range/input.text = str(config.pitch_randomizer_range)

func _on_dir_selected(dir: String):
	config.sfx_directory = dir
	$config_container/sfx_directory/input.text = config.sfx_directory
	save()

func _on_browse_pressed() -> void:
	$config_container/sfx_directory/FileDialog.show()

func save():
	ResourceSaver.save(config, config.resource_path)

func _on_input_text_changed(new_text:String) -> void:
	config.pitch_randomizer_range = float(new_text)
	save()