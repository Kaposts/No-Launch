extends AudioStreamPlayer
## Autoload node for game music player
## Author: Lestavol
##

enum SongNames {
	PRE_BATTLE,
	MAIN_BATTLE,
	POST_BATTLE,
	TITLE_THEME,
}

var _playback_position: float = 0.0

@export var music_streams: Array[AudioStream]
@onready var between_song_timer: Timer = $BetweenSongTimer


func _ready():
	finished.connect(_on_finished)
	between_song_timer.timeout.connect(_on_between_songs_timer_timeout)


func switch_song(track: SongNames, fade_in: bool = true, from_start: bool = false) -> void:
	if stream == music_streams[track]:
		return
	
	if from_start:
		_playback_position = 0.0
	else:
		_playback_position = get_playback_position()
		_playback_position += AudioServer.get_time_since_last_mix()
	
	if fade_in:
		between_song_timer.start()
		var tween: Tween = create_tween()
		tween.tween_property(self, "volume_linear", 0.2, between_song_timer.wait_time / 2)\
		.set_ease(Tween.EASE_OUT)\
		.set_trans(Tween.TRANS_CUBIC)
		await tween.finished
	
	stream = music_streams[track]

	
	if fade_in:
		var tween: Tween = create_tween()
		tween.tween_property(self, "volume_linear", 1.0, between_song_timer.wait_time / 2)\
		.set_ease(Tween.EASE_IN)\
		.set_trans(Tween.TRANS_SINE)
	else:
		play(_playback_position)


func _on_finished():
	_playback_position = 0.0
	between_song_timer.start()


func _on_between_songs_timer_timeout():
	play(_playback_position if _playback_position < stream.get_length() else 0.0)
