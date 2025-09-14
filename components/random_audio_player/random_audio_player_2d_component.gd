class_name RandomAudioPlayer2D
extends AudioStreamPlayer2D
## Random Audio Stream Player 2D
##
## Positional sound player that plays a randomized SFX (pitch-shifted and random-selected) from list


@export var streams: Array[AudioStream]
@export var randomize_pitch: bool = true
@export var min_pitch: float = .9
@export var max_pitch: float = 1.1


func play_random() -> void:
	play_randomized_pitch_at(randi_range(0, streams.size() - 1))


func play_randomized_pitch_at(stream_index: int) -> void:
	if streams == null || streams.is_empty():
		return
	
	if stream_index < 0 or stream_index >= streams.size():
		assert(false, "Trying to play a invalid stream index, from " + owner.name)
	
	if randomize_pitch:
		pitch_scale = randf_range(min_pitch, max_pitch)
	else:
		pitch_scale = 1
	
	stream = streams[stream_index]
	play()
