extends Node

const SCENE_PATHS: Dictionary[String, String] = {
	"navigator_component" : "uid://brbg6i0mvo0l8",
}

const GROUP_DROP_ZONE = "drop_zone"

var cards_in_hand: Array[Card] = []
var cards_in_play: Array[Card] = []
var deck: Array[CardData] = []

@onready var deck_data: DeckData = preload("res://cards/deck/deck.tres")
var energy: int = 10
var deck_size = 20

var is_playing_turn: bool = false

func _ready() -> void:
	deck_size = deck_data.size
	SceneManager.transition_finished.connect(func(): print('Transition complete'))
	SceneManager.fade_complete.connect(func(): print('Fade complete'))
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

func draw(amount: int = 1) -> void:
	if deck.size() <= 0: return

	for i in amount:
		var card = deck.pop_front()
		Audio.play_random(SFX.SFX_UI_SWITCH_006)
		SignalBus.update_hand.emit()
		SignalBus.draw_card.emit(card)

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
	for card in cards_in_play:
		await get_tree().create_timer(0.3).timeout
		SignalBus.play_card.emit(card)
		discard(card)
	cards_in_play.clear()

	SignalBus.update_hand.emit()

	is_playing_turn = false

func increase_energy(amount: int):
	energy += amount
	SignalBus.update_energy.emit(energy)
