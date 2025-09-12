
extends Control
class_name Hand

@export var card_scene: PackedScene
@export var hand_curve: Curve
@export var rotation_curve: Curve
@export var max_rotation_curve := 5
@export var x_sep: int = -10
@export var y_min := 0
@export var y_max := -15

var cards_in_hand: Array[Card] = []
var cards_in_play: Array[Card] = []

var energy: int = 10

func _process(delta):
	get_parent().get_node('Label').text = str(cards_in_play)

func _ready():
	SignalBus.activate_card.connect(_on_activate_card)
	SignalBus.deactivate_card.connect(_on_deactivate_card)

func draw() -> void:
	var new_card = card_scene.instantiate()
	cards_in_hand.append(new_card)
	add_child(new_card)
	_update_cards()

func discard(card) -> void:
	if cards_in_hand.size() < 1:
		push_error("You have no cards")
		return
	cards_in_hand.erase(card)
	card.queue_free()

func _update_cards():
	var cards := cards_in_hand.size()
	var all_cards_size := 100 * cards + x_sep * (cards - 1)
	var final_x_sep := x_sep

	if all_cards_size > size.x:
		final_x_sep = (size.x - 100 * cards) / (cards - 1)
		all_cards_size = size.x
	
	var offset := (size.x - all_cards_size) / 2

	for i in cards:
		var card := get_child(i)
		var y_multiplier := hand_curve.sample(1.0 / (cards-1) * i)
		var rot_multiplier := rotation_curve.sample(1.0 / (cards-1) * i)

		if cards == 1:
			y_multiplier = 0.0
			rot_multiplier = 0.0

		var final_x: float = offset + 100 * i + final_x_sep * i
		var final_y: float = y_min + y_max * y_multiplier

		var target_pos := Vector2(final_x, final_y)
		var target_rot := max_rotation_curve * rot_multiplier

		var tween := create_tween()

		tween.tween_property(card, "position", target_pos, 0.3)
		tween.tween_property(card, "rotation_degrees", target_rot, 0.3)

func _on_draw_pressed() -> void:
	draw()

func _on_play_turn_pressed() -> void:
	print("You did your turn")
	for card in cards_in_play:
		discard(card)
	cards_in_play.clear()

	##FOR some weird reason it doesnt work without timeout	
	await get_tree().create_timer(0.1).timeout
	_update_cards()


func _on_activate_card(card: Card) -> void:
	energy -= card.data.energy
	cards_in_play.append(card)
	SignalBus.update_energy.emit(energy)

func _on_deactivate_card(card: Card) -> void:
	energy += card.data.energy
	cards_in_play.erase(card)
	SignalBus.update_energy.emit(energy)
