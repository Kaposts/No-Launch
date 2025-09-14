extends Node

func _ready():
	SignalBus.update_energy.connect(_on_update_energy)
	SignalBus.update_hand.connect(_on_update_hand)
	SignalBus.round_effect_activate.connect(_on_round_effect_activate)

func _on_update_energy(value):
	$energy.text = "Executive Power: " + str(value) +"/"+ str(Global.max_energy)
func _on_update_hand():
	$cards_in_deck.text = "Cards insinde deck: " + str(Global.deck.size())

func _on_play_turn_pressed() -> void:
	Global.play_turn()

func _on_play_turn_2_pressed() -> void:
	SignalBus.end_round.emit()

func _on_round_effect_activate(description: String):
	$round_effect.show()
	$round_effect/AnimationPlayer.play("show")
	$round_effect/BG/description.text = description

func _on_round_effect_close_pressed() -> void:
	$round_effect.hide()
