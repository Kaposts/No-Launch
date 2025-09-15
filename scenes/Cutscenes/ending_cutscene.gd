extends Node


func _ready():
	Dialogic.signal_event.connect(_on_dialogic_signal)
	Dialogic.start("Cutscene3")
	
	MusicPlayer.switch_song(MusicPlayer.SongNames.ENDING_CUTSCENE, false, true)


func _on_dialogic_signal(argument: String):
	if argument == "BlueScreen":
		$AnimationPlayer.play("BlueScreen")
		Dialogic.start("Cutscene4")
	if argument == "END":
		await Global.transition()
		get_tree().change_scene_to_file("res://scenes/UI/MainMenu.tscn")
