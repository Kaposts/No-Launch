# BGMManager.gd
extends Node

@export var fade_time: float = 1.0
var player: AudioStreamPlayer
var player2: AudioStreamPlayer
var current_player: AudioStreamPlayer
var next_player: AudioStreamPlayer

func _ready():
    player = AudioStreamPlayer.new()
    player2 = AudioStreamPlayer.new()
    add_child(player)
    add_child(player2)
    current_player = player
    next_player = player2

func play_bgm(stream: AudioStream, loop: bool = true):
    if current_player.playing:
        # Fade out current and fade in new
        next_player.stream = stream
        next_player.volume_db = -80
        next_player.loop = loop
        next_player.play()
        crossfade(current_player, next_player)
    else:
        current_player.stream = stream
        current_player.loop = loop
        current_player.play()

func crossfade(from_player: AudioStreamPlayer, to_player: AudioStreamPlayer):
    var t = 0.0
    while t < fade_time:
        t += get_process_delta_time()
        from_player.volume_db = lerp(0, -80, t / fade_time)
        to_player.volume_db = lerp(-80, 0, t / fade_time)
        # yield(get_tree(), "idle_frame")
    from_player.stop()
    # Swap players
    var temp = current_player
    current_player = next_player
    next_player = temp
