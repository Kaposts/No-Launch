extends Node

func _ready():
	SignalBus.play_card.connect(_on_play_card)

func _on_play_card(card: Card):
	print(card)
	for activation in card.data.activations:
		match activation.function:
			Enum.CARD_FUNCTION.DRAW_CARD:
				print('watafaku')
				Global.draw()
			Enum.CARD_FUNCTION.INCREASE_ENERGY:
				#INCREASE_ENERGY
				pass
			Enum.CARD_FUNCTION.INCREASE_ARMY_SIZE:
				#INCREASE_ARMY_SIZE
				pass
			Enum.CARD_FUNCTION.BUFF_ARMY:
				#BUFF_ARMY
				pass
