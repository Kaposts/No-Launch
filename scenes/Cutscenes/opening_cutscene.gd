extends Node


func _ready():
	Dialogic.signal_event.connect(_on_dialogic_signal)
	Dialogic.start("Cutscene1")
	
	pass
	


func _on_dialogic_signal(argument: String):
	if argument == "Angry_Switch":
		$AnimationPlayer.play("OpeningDayExist")
		Dialogic.start("Cutscene2")
	
	if argument == "Game_Start":
		await Global.transition()
		get_tree().change_scene_to_file("res://scenes/cabage.tscn")
		SignalBus.start_game.emit()
