extends Control

@onready var back_button = $TextureRect/CloseButton
signal exit_options_menu

func Master_Volume(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"),value)
	
	if value == -30:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"),true)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"),false)
		
func Music_Volume(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"),value)
	
	if value == -30:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"),true)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"),false)
		
func SFX_Volume(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"),value)
	
	if value == -30:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"),true)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"),false)

func _on_master_slider_value_changed(value: float) -> void:
		Master_Volume(value)

func _on_master_slider_mouse_exited() -> void:
	self.release_focus()

func _on_music_value_changed(value: float) -> void:
	Music_Volume(value)

func _on_music_mouse_exited() -> void:
	self.release_focus()

func _on_SFX_value_changed(value: float) -> void:
	SFX_Volume(value)

func _on_SFX_mouse_exited() -> void:
	self.release_focus()
