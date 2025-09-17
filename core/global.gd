extends Node

const SCENE_PATHS: Dictionary[String, String] = {
	"navigator_component" : "uid://brbg6i0mvo0l8",
	"floating_text" : "uid://c6brqedq46jjh",
}

const GROUP_DROP_ZONE = "drop_zone"

var card_in_hand_limit: int = 15

var cards_in_hand: Array[Card] = []
var cards_in_play: Array[Card] = []
var deck: Array[CardData] = []

# @onready var deck_data: DeckData = preload("res://cards/deck/test_deck.tres")
@onready var deck_data: DeckData = preload("res://cards/deck/deck.tres")
const energy_cap: int = 15
var max_energy: int = 4
var energy: int = 4
var deck_size = 5000
var card_draw_per_round: int = 3
var is_playing_turn: bool = false

var game_is_paused: bool = false

var skip_cut_scenes: bool = true

func _ready() -> void:
	SceneManager.transition_finished.connect(func(): print('Transition complete'))
	SceneManager.fade_complete.connect(func(): print('Fade complete'))

	SignalBus.end_round.connect(_on_end_round)
	SignalBus.start_game.connect(_on_start_game)

func transition():
	SceneManager.fade_out()
	await SceneManager.fade_complete
	SceneManager.fade_in()

func _on_start_game():
	# reset values
	game_is_paused = false
	
	cards_in_hand = []
	cards_in_play = []
	deck = []

	energy = max_energy
	# deck_size = deck_data.size
	starting_hand()
	await get_tree().create_timer(2).timeout
	RoundEffect.change_effect()
	SignalBus.game_started.emit()

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
	var card_data: CardData

	for i in amount:
		if type >= 0:
			card_data = get_card_by_rarity(deck, type)
			if !card_data: return
			deck.erase(card_data)
		else:
			card_data = pop_deck_by_weight()

		SignalBus.update_hand.emit()
		SignalBus.draw_card.emit(card_data)

func pop_deck_by_weight():
	var total_weight = 0
	for card_data: CardData in deck_data.card_pool:
		total_weight += card_data.weight

	# Pick a random number between 0 and total_weight
	var r = randi() % total_weight
	var running_sum = 0

	# Find which card corresponds to r
	for card_data: CardData  in deck_data.card_pool:
		running_sum += card_data.weight
		if r < running_sum:
			# card_data.duplicate(true)
			# card_data.resource_path = ""
			return card_data

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

	# SignalBus.update_hand.emit()
	SignalBus.start_round.emit()

func play_card(card: Card) -> void:
	energy -= card.data.energy
	SignalBus.update_energy.emit(energy)
	
	if RoundEffect.double_or_nothing:
		if card.double:
			SignalBus.play_card.emit(card)
			SignalBus.play_card.emit(card)
			discard(card)
			SignalBus.update_hand.emit()
			return
		else:
			discard(card)
			return

	card_kill_robot_maybe()

	SignalBus.play_card.emit(card)

	discard(card)

	SignalBus.update_hand.emit()

func card_kill_robot_maybe():

	if RoundEffect.card_kill_robot_maybe:
		if randi_range(1, 3) == 1:
			var layer = get_tree().get_first_node_in_group("player_layer")
			if layer.get_child_count() > 0:
				layer.get_children().pick_random().queue_free()

func increase_energy(amount: int):
	
	max_energy += amount
	
	if max_energy >= energy_cap:
		max_energy = energy_cap
	
	GlobalSfxPlayer.energy_increased_sfx_player.play_random()
	SignalBus.max_enery_increased.emit(amount)
	SignalBus.update_energy.emit(energy)

func fill_energy(amount: int):
	if amount == -1:
		energy = max_energy
	elif energy + amount > max_energy:
		energy = max_energy
	else:
		energy += amount
	
	GlobalSfxPlayer.energy_increased_sfx_player.play_random()
	SignalBus.max_enery_increased.emit(amount)
	SignalBus.update_energy.emit(energy)

func _on_end_round():
	if game_is_paused: return
	
	is_playing_turn = false
	energy = max_energy

	SignalBus.update_energy.emit(energy)

	for i in card_draw_per_round:
		await get_tree().create_timer(0.2).timeout
		draw()

func duplicate_hand():
	var cards_to_dup = cards_in_hand

	## SORRY I AM TOO TIRED AND SPENT ALREADY TOO MUCH TIME TO FIX THIS PROPERLY
	for card in cards_to_dup:
		var skip: bool = false
		if !card: return
		var card_data = card.data
		for activation:ActivationResource in card_data.activations:
			if activation.function == Enum.CARD_FUNCTION.DUPLICATE_HAND: 
				skip = true
				continue
		
		if skip: continue

		await get_tree().create_timer(0.2).timeout
		create_card(card.data)

func corrupt_cards():
	var amount_to_corrupt

	if cards_in_hand.size() <= 0:
		push_warning("Corruption FAILED, No card found")
		return

	if cards_in_hand.size() > 4:
		amount_to_corrupt = 2
	elif cards_in_hand.size() > 6:
		amount_to_corrupt = 3
	else:
		amount_to_corrupt = 1


	for i in amount_to_corrupt:
		var card: Card = cards_in_hand.pick_random()
		card.corrupt()

func big_update():
	var damage_nexus_activation = load("res://cards/resources/activations/nexus/damage_nexus_1.tres")

	for card in cards_in_hand:
		var new_data = CardData.new()
		new_data = card.data.duplicate(true)
		new_data.resource_path = ""
		var picked_card = deck_data.card_pool.pick_random()
		new_data.activations.append(picked_card.activations[0])
		new_data.activations.append(damage_nexus_activation.duplicate(true))
		new_data.energy += 2
		card.energy_cost.text = str(new_data.energy)
		card.data = new_data

		card.card_description.text = ""
		card.generate_description()
