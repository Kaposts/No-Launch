extends Node

func _ready():
    SignalBus.update_energy.connect(_on_update_energy)
    SignalBus.update_hand.connect(_on_update_hand)

func _on_update_energy(value):
    $energy.text = "Executive Power: " + str(value) +"/"+ str(Global.max_energy)
func _on_update_hand():
    $cards_in_deck.text = "Cards insinde deck: " + str(Global.deck.size())

func _on_play_turn_pressed() -> void:
    Global.play_turn()

func _on_play_turn_2_pressed() -> void:
    SignalBus.end_round.emit()
