extends Node

func _ready():
    SignalBus.update_energy.connect(_on_update_energy)

func _on_update_energy(value):
    $energy.text = "Executive Power: " + str(value) + "/10"

func _on_play_turn_pressed() -> void:
    Global.play_turn()
