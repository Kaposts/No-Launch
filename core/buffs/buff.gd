extends Node
class_name Buff

var data: ActivationResource

var rounds: int = 1

func _ready():
	rounds = data.rounds

func _on_round_start():
	pass

func _on_round_end():
	rounds -= 1
	if rounds <= 0:
		queue_free()
	pass
