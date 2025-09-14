extends Node

const SCENE_PATHS: Dictionary[String, String] = {
	"navigator_component" : "uid://brbg6i0mvo0l8",
}

const GROUP_DROP_ZONE = "drop_zone"

var cards_in_hand: Array[Card] = []
var cards_in_play: Array[Card] = []
var deck: Array[CardData] = []

@onready var deck_data: DeckData = preload("res://cards/deck/deck.tres")
var max_energy: int = 10
var energy: int = 10
var deck_size = 20
var card_draw_per_round: int = 2
var is_playing_turn: bool = false

func _ready() -> void:
	energy = max_energy
	deck_size = deck_data.size

	SceneManager.transition_finished.connect(func(): print('Transition complete'))
	SceneManager.fade_complete.connect(func(): print('Fade complete'))

	SignalBus.end_round.connect(_on_end_round)

	starting_hand()

func transition():
	SceneManager.fade_out()
	await SceneManager.fade_complete
	SceneManager.fade_in()

func starting_hand():
	for i in 5:
		await get_tree().create_timer(0.2).timeout
		draw()

func deck_setup():
	for i in deck_size:
		Global.deck.append(deck_data.card_pool.pick_random())

func get_card_by_rarity(cards: Array, rarity: Enum.CARD_RARITY) -> CardData:
	for card: CardData in cards:
		if card.rarity == rarity:
			return card
	return null

func draw(amount: int = 1, type: int = -1) -> void:
	if deck.size() <= 0: return
	var card

	for i in amount:
		if type >= 0:
			card = get_card_by_rarity(deck, type)
			deck.erase(card)
		else:
			card = deck.pop_front()

		SignalBus.update_hand.emit()
		SignalBus.draw_card.emit(card)

func create_card(data: CardData):
	SignalBus.update_hand.emit()
	SignalBus.draw_card.emit(data)

func discard(card) -> void:
	if cards_in_hand.size() < 1:
		push_error("You have no cards")
		return
	cards_in_hand.erase(card)
	if card:
		card.queue_free()
	else:
		push_warning("THE CARD DISSAPEARED SOMEWHERE")

func play_turn() -> void:
	is_playing_turn = true
	print("You did your turn")
	print(cards_in_play)
	# for card in cards_in_play:
	# 	await get_tree().create_timer(0.3).timeout
	# 	SignalBus.play_card.emit(card)
	# 	discard(card)
	# cards_in_play.clear()

	# SignalBus.update_hand.emit()
	SignalBus.start_round.emit()

func play_card(card: Card) -> void:
	energy -= card.data.energy 
	
	SignalBus.play_card.emit(card)

	discard(card)

	SignalBus.update_hand.emit()
	SignalBus.update_energy.emit(energy)

func increase_energy(amount: int):
	max_energy += amount
	SignalBus.update_energy.emit(energy)

func fill_energy(amount: int):
	if amount == -1:
		energy = max_energy
	elif energy + amount > max_energy:
		energy = max_energy
	else:
		energy += amount
		
	SignalBus.update_energy.emit(energy)

func _on_end_round():
	is_playing_turn = false
	energy = max_energy

	SignalBus.update_energy.emit(energy)

	for i in card_draw_per_round:
		await get_tree().create_timer(0.2).timeout
		draw()

func duplicate_hand():
	var cards_to_dup = cards_in_hand
	## SORRY I AM TOO TIRED AND SPENT ALREADY TOO MUCH TIME TO FIX THIS PROPERLY
	for card in cards_to_dup.size():
		await get_tree().create_timer(0.2).timeout
		create_card(cards_to_dup[card].data)
		print('WHATE HELLYY',card)