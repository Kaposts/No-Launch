extends Node
class_name Buff

var data: ActivationResource

var rounds: int = 1

func _ready():
	rounds = data.rounds
	if data is ArmySizeResource:
		rounds -= 1
		for i in data.army_amount:
			SignalBus.spawn_player.emit()
			await get_tree().create_timer(0.2).timeout
	if data is ArmyBuffResource:
		SignalBus.apply_buff.emit(data)

func _on_round_start():
	pass

func _on_round_end():
	rounds -= 1
	if rounds <= 0:
		queue_free()
	pass
