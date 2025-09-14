extends Node

func _ready():
	SignalBus.update_energy.connect(_on_update_energy)
	SignalBus.update_hand.connect(_on_update_hand)
	SignalBus.round_effect_activate.connect(_on_round_effect_activate)
	SignalBus.round_effect_hide.connect(on_round_effect_hide)

func _on_update_energy(value):
	$energy.text = "Executive Power: " + str(value) +"/"+ str(Global.max_energy)
func _on_update_hand():
	$cards_in_deck.text = "Cards insinde deck: " + str(Global.deck.size())

func _on_play_turn_pressed() -> void:
	Global.play_turn()

func _on_play_turn_2_pressed() -> void:
	SignalBus.end_round.emit()

func on_round_effect_hide():
	$round_effect/AnimationPlayer.play("hide")

func _on_round_effect_activate(description: String):
	$round_effect.show()
	$round_effect/AnimationPlayer.play("show")
	$round_effect/BG/description.text = description

func _on_round_effect_close_pressed() -> void:
	$round_effect.hide()

func _input(event):
	if event is InputEventKey:
		if event.pressed and not event.echo:
			if event.keycode == KEY_ESCAPE:
				if $OptionsMenu.visible:
					$OptionsMenu.hide()
				else:
					$OptionsMenu.show()