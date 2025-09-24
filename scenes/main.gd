extends Node2D
## Main scene script

func _ready() -> void:
	SignalBus.start_game.emit()
