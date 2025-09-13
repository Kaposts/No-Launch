## Write global signals here
extends Node

signal activate_card(card: Card)
signal deactivate_card(card: Card)
signal update_energy(value: int)


signal update_hand()
signal draw_card(card_data: CardData)
signal play_card(card: Card)

signal start_round()
signal end_round()