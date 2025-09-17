extends Node2D

func _ready() -> void:
	SignalBus.start_game.emit()
