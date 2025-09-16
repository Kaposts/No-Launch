@tool
extends Node

var audios: Array[AudioData] = []
var config: AudioManagerConfig

func _ready():
	config = load("res://addons/audio_manager/config/config.tres")
	setup_sfx()
	setup_bgm()


## SFX PARAMATERS AND FUNCTIONS
var max_channels: int = 8
var channels = []

const RESOURCE_EXTENSION = ".tres"
const LIBRARY_PATH = "res://addons/audio_manager/resources/audios/"

func setup_sfx():
	audios = read_dir()

	print(audios)

	for i in range(max_channels):
		var player = AudioStreamPlayer.new()
		add_child(player)
		channels.append(player)

#player_override types: AudioStreamPlayer, AudioStreamPlayer2D, AudioStreamPlayer3D
func play(audio: AudioData, player_override = null):

	## TODO Duplicate code fix later
	if player_override:
		assert(
			player_override is AudioStreamPlayer \
			or player_override is AudioStreamPlayer2D \
			or player_override is AudioStreamPlayer3D,
			"player_override must be AudioStreamPlayer, AudioStreamPlayer2D, or AudioStreamPlayer3D"
		)

		player_override.stream = audio.res_stream
		player_override.volume_db = audio.res_volume_db
		player_override.pitch_scale = audio.res_pitch_scale
		player_override.autoplay = true

		if audio.res_pitch_randomizer:
			var range = config.pitch_randomizer_range
			var rand := randf_range(-1 * range, range)
			player_override.pitch_scale += rand

		player_override.play()

		return


	for player: AudioStreamPlayer in channels:
		if not player.playing:
			player.stream = audio.res_stream
			player.volume_db = audio.res_volume_db
			player.pitch_scale = audio.res_pitch_scale
			player.autoplay = true

			if audio.res_pitch_randomizer:
				var range = config.pitch_randomizer_range
				var rand := randf_range(-1 * range, range)
				player.pitch_scale += rand

			player.play()
			return

	# If all channels busy, play on first one (optional)
	# channels[0].stream = stream
	# channels[0].volume_db = volume_db
	# channels[0].pitch_scale = pitch_scale
	# channels[0].play()

func play_by_name(sound_name: String, player_override = null):
	for audio: AudioData in audios:
		if audio.res_name == sound_name:
			play(audio, player_override)
			return

	push_error("Audio not found")
	return

func play_random(prefix: String, player_override = null) -> void:

	var matches := audios.filter(
		func(audio: AudioData): 
			if !audio: return
			return audio.res_name.begins_with(prefix)
			)

	if matches.is_empty():
		push_warning("No sounds found with prefix: %s" % prefix)
		return
	var chosen: AudioData
	chosen = matches[randi() % matches.size()]
	play(chosen, player_override)

var play_index: Dictionary = {} # keeps track of last played index per prefix

func play_sequenctial(prefix: String, player_override = null) -> void:
	var matches := audios.filter(func(a): return a.res_name.begins_with(prefix))
	var idx := play_index.get(prefix, 0)
	var chosen: AudioData
	chosen = matches[idx]
	idx = (idx + 1) % matches.size()
	play_index[prefix] = idx

	play(chosen, player_override)

func read_dir() -> Array[AudioData]:
	audios = []
	var path = LIBRARY_PATH

	var dir = DirAccess.open(path)
	if dir == null:
		push_error("Audio Manager cannot open folder: %s" % path)
		return []

	dir.list_dir_begin()
	var filename = dir.get_next()

	while filename != "":
		# skip hidden files
		if filename.begins_with("."):
			filename = dir.get_next()
			continue

		elif filename.get_extension().to_lower() in RESOURCE_EXTENSION:
				var resource: AudioData = load(path + filename)

				if !resource: 
					push_warning(resource,"resource " + filename + " was not found")
					filename = dir.get_next()
					continue

				audios.append(resource)
		else: 
			push_error('The extension for this file is not supported: ', filename)

		filename = dir.get_next()

	dir.list_dir_end()

	return audios


##BGM PARAMATERS AND FUNCTIONS
@export var fade_time: float = 5
var current_player: AudioStreamPlayer
var next_player: AudioStreamPlayer

func setup_bgm():
	current_player = AudioStreamPlayer.new()
	next_player = AudioStreamPlayer.new()
	add_child(current_player)
	add_child(next_player)

func play_bgm(stream: AudioStream, loop: bool = true):
	stream.loop = loop

	# Fade out current and fade in new
	next_player.stream = stream
	next_player.volume_db = -80
	next_player.play()
	crossfade(current_player, next_player)

	var temp_player: AudioStreamPlayer = next_player
	next_player = current_player
	current_player = temp_player

func crossfade(from_player: AudioStreamPlayer, to_player: AudioStreamPlayer):
	var t := 0.0
	
	to_player.play()
	to_player.seek(15)
	
	while t < fade_time:
		await get_tree().process_frame
		t += get_process_delta_time()
		var alpha := clamp(t / fade_time, 0.0, 1.0)
		to_player.volume_db = lerp(-20.0, 0.0, alpha)
		from_player.volume_db = lerp(0.0, -20.0, alpha)

	# stop old player after fade completes
	from_player.stop()
