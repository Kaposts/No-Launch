extends Node

@onready var card_scene = preload("res://cards/scenes/card.tscn")

func _ready():
	print(Global.deck_data.card_pool)
	# return
	for card in Global.deck_data.card_pool:
		print(card)
		var xd = card_scene.instantiate()
		xd.data = card
		add_child(xd)
