extends Node

const SCENE_PATHS: Dictionary[String, String] = {
	"navigator_component" : "uid://brbg6i0mvo0l8",
}

const GROUP_DROP_ZONE = "drop_zone"

var cards_in_hand: Array[Card] = []
var cards_in_play: Array[Card] = []
var deck: Array[CardData] = []

func _ready() -> void:
	SceneManager.transition_finished.connect(func(): print('Transition complete'))
	SceneManager.fade_complete.connect(func(): print('Fade complete'))
	starting_hand()

func transition():
	SceneManager.fade_out()
	await SceneManager.fade_complete
	SceneManager.fade_in()

func starting_hand():
	for i in 5:
		await get_tree().create_timer(0.1).timeout
		draw()

func draw() -> void:
	var card = deck.pop_front()
	Audio.play_random(SFX.SFX_UI_SWITCH_006)
	SignalBus.update_hand.emit()
	SignalBus.draw_card.emit(card)

func discard(card) -> void:
	if cards_in_hand.size() < 1:
		push_error("You have no cards")
		return
	cards_in_hand.erase(card)
	card.queue_free()

func play_turn() -> void:
	print("You did your turn")
	for card in cards_in_play:
		await get_tree().create_timer(0.3).timeout
		SignalBus.play_card.emit(card)
		discard(card)
	cards_in_play.clear()

	SignalBus.update_hand.emit()
