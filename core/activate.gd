extends Node

func _ready():
	SignalBus.play_card.connect(_on_play_card)

func _on_play_card(card: Card):
	print(card)
	for activation: ActivationResource in card.data.activations:
		match activation.function:
			Enum.CARD_FUNCTION.DRAW_CARD:
				for i in activation.amount:
					await get_tree().create_timer(0.2).timeout
					Global.draw(1)
			Enum.CARD_FUNCTION.INCREASE_ENERGY:
				print(activation.amount)
				Global.increase_energy(activation.amount)
			Enum.CARD_FUNCTION.INCREASE_ARMY_SIZE:
				PlayerBuffs.assign_card(activation)
			Enum.CARD_FUNCTION.BUFF_ARMY:
				PlayerBuffs.assign_card(activation)
