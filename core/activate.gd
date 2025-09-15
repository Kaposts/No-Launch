extends Node

func _ready():
	SignalBus.play_card.connect(_on_play_card)

func _on_play_card(card: Card):
	Audio.play_by_name(SFX.SFX_UI_CLICK_003)
	for activation: ActivationResource in card.data.activations:
		match activation.function:
			Enum.CARD_FUNCTION.DRAW_CARD:
				for i in activation.amount:
					await get_tree().create_timer(0.2).timeout
					Global.draw(1, activation.rarity)

			Enum.CARD_FUNCTION.INCREASE_ENERGY:
				Global.increase_energy(activation.amount)

			Enum.CARD_FUNCTION.FILL_ENERGY:
				Global.fill_energy(activation.amount)

			Enum.CARD_FUNCTION.INCREASE_ARMY_SIZE:
				PlayerBuffs.assign_card(activation)

			Enum.CARD_FUNCTION.BUFF_ARMY:
				PlayerBuffs.assign_card(activation)

			Enum.CARD_FUNCTION.HEAL_NEXUS:
				get_tree().get_first_node_in_group("player_nexus")._on_heal_nexus(activation.heal_amount)

			Enum.CARD_FUNCTION.DUPLICATE_HAND:
				Global.duplicate_hand()
