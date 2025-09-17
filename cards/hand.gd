
extends Control
class_name Hand

@export var card_scene: PackedScene
@export var hand_curve: Curve
@export var rotation_curve: Curve
@export var max_rotation_curve := 5
@export var x_sep: int = -10
@export var y_min := 0
@export var y_max := -15

@export var card_pool: Array[CardData] = []

func _ready():
	SignalBus.activate_card.connect(_on_activate_card)
	SignalBus.deactivate_card.connect(_on_deactivate_card)
	SignalBus.update_hand.connect(_update_cards)
	SignalBus.draw_card.connect(_on_draw_card)


func _on_draw_card(card_data: CardData):
	if Global.cards_in_hand.size() >= Global.card_in_hand_limit: return
	var new_card = card_scene.instantiate()
	new_card.data = card_data
	Global.cards_in_hand.append(new_card)
	add_child(new_card)

func _update_cards():

	await get_tree().create_timer(0.2).timeout
	
	var cards_count: int= Global.cards_in_hand.size()
	var all_cards_size := 100 * cards_count + x_sep * (cards_count - 1)
	var final_x_sep := x_sep

	if all_cards_size > size.x:
		final_x_sep = (size.x - 100 * cards_count) / (cards_count - 1)
		all_cards_size = size.x
	
	var offset := (size.x - all_cards_size) / 2

	for i in cards_count:
		var card := get_child(i)
		var y_multiplier := hand_curve.sample(1.0 / (cards_count-1) * i)
		var rot_multiplier := rotation_curve.sample(1.0 / (cards_count-1) * i)

		if cards_count == 1:
			y_multiplier = 0.0
			rot_multiplier = 0.0

		var final_x: float = offset + 100 * i + final_x_sep * i
		var final_y: float = y_min + y_max * y_multiplier

		var target_pos := Vector2(final_x, final_y)
		var target_rot := max_rotation_curve * rot_multiplier

		var tween := create_tween()

		tween.tween_property(card, "position", target_pos, 0.3)
		tween.tween_property(card, "rotation_degrees", target_rot, 0.3)

func _on_activate_card(card: Card) -> void:
	Global.energy -= card.data.energy
	Global.cards_in_play.append(card)
	SignalBus.update_energy.emit(Global.energy)

func _on_deactivate_card(card: Card) -> void:
	Global.energy += card.data.energy
	Global.cards_in_play.erase(card)
	SignalBus.update_energy.emit(Global.energy)
