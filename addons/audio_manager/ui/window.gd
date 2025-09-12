@tool
extends Window
class_name SFXManagerWindow

var audios: Array[AudioData] = [] 
var results: Array[AudioData] = [] 

@onready var library_label: Label = $SFX/Label
@onready var audios_controls = $SFX/Audios/v_box

@onready var loadBut: Button = $VBoxContainer/Load
@onready var info: Label = $info

func load_library():
	audios = Audio.read_dir()
	results = audios
	load_audios()

func _on_close_pressed() -> void:
	queue_free()

func _on_config_pressed() -> void:
	hide_tabs()
	$Config.show()

func _on_bgm_pressed() -> void:
	hide_tabs()
	$BGM.show()

func _on_sfx_pressed() -> void:
	hide_tabs()
	$SFX.show()

func hide_tabs():
	$Welcome.hide()
	$SFX.hide()
	$Config.hide()
	$BGM.hide()


## STUFF FOR CONTROLING SOUNF EFFECTS
## TODO maybe move it inside sfx_control.gd

func load_audios():
	library_label.text = "Audios: " + str(results.size())
	results.sort_custom(func(a: AudioData, b: AudioData) -> bool:
		return a.res_name < b.res_name
	)

	for audio in results:
		var control: SFXControl = load("res://addons/audio_manager/ui/sfx_control.tscn").instantiate()

		control.set_name_label(audio.res_name)
		control.set_volume_slider(audio.res_volume_db)
		control.set_pitch_slider(audio.res_pitch_scale)
		control.set_resource(audio)
		control.set_pitch_randomizer(audio.res_pitch_randomizer)

		audios_controls.add_child(control)

func clear_audios():
	var ui = $SFX/Audios/v_box
	for child in ui.get_children():
		child.queue_free()

func _on_search_text_changed() -> void:
	var query: String = $SFX/search.text.strip_edges().to_lower()
	results = []

	for audio in audios:
		if query == "" or audio.res_name.to_lower().find(query) != -1:
			results.append(audio)
	clear_audios()
	load_audios()
