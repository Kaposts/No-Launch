extends Node2D

@export var music_1: AudioStream
@export var music_2: AudioStream

func _on_play_by_name_pressed() -> void:
	Audio.play_by_name(SFX.SFX_UI_CLICK_001)

func _on_play_random_pressed() -> void:
	Audio.play_random('sfx_click')

func _on_play_sequence_pressed() -> void:
	Audio.play_sequenctial('sfx_click')

func _on_play_bgm_2_pressed() -> void:
	Audio.play_bgm(music_1)


func _on_play_bgm_pressed() -> void:
	Audio.play_bgm(music_2)

func _on_play_2d_sound_pressed() -> void:
	Audio.play_by_name('sfx_ui_close_002', $Icon/AudioStreamPlayer2D)
