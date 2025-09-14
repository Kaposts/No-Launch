extends Control
class_name Card

# @onready var hand: Hand = get_parent()

@export var data: CardData
@export var anim: AnimationPlayer

@export var rarity_sprites: Array[Texture] #THE ORDER NEEDS TO MATCH WITH enum.gd

const ANIM_DRAW = "draw"
const ANIM_ENTER = "enter"
const ANIM_DROP = "drop"
const ANIM_EXIT = "exit"

var is_hovered := false
var is_dragging := false
var is_activated := false
var corrupted := false
var drag_offset: Vector2

@onready var card_background = $Container/background
@onready var card_sprite = $Container/info/sprite
@onready var energy_cost = $Container/info/energy_cost
@onready var rarity = $Container/info/rarity
@onready var card_name = $Container/info/Name
@onready var card_description = $Container/info/Description
@onready var highlight = $Container/highlight


func _ready():
	#SO THAT WHEN DRAWING YOU CAN'T RUIN CARDS ROTTATION
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	anim.play(ANIM_DRAW)

	anim.animation_finished.connect(_on_anim_finished)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

	# card_background.texture = data.background
	card_sprite.texture = data.sprite
	card_name.text = data.name
	energy_cost.text = str(data.energy)
	rarity.texture = rarity_sprites[data.rarity]

	generate_description()

func _on_anim_finished(anim_name: StringName):
	if anim_name == ANIM_DRAW:
		mouse_filter = Control.MOUSE_FILTER_STOP
		Audio.play_by_name(SFX.SFX_UI_CLICK_005)
	if anim_name == ANIM_DROP:
		Global.play_card(self)

func _on_mouse_entered():
	if Global.is_playing_turn: return
	Audio.play_by_name(SFX.SFX_UI_TICK_004)
	is_hovered = true
	if not is_dragging:
		anim.play(ANIM_ENTER)

func _on_mouse_exited():
	if Global.is_playing_turn: return
	is_hovered = false
	if not is_dragging:
		anim.play(ANIM_EXIT)


# bunch of if corrupted:return are placed so that the card functionality doesnt work but the close button is clickable, better approach is yet to discover
func _on_gui_input(event: InputEvent) -> void:
	if Global.is_playing_turn: return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if Global.energy - data.energy < 0: return
		if event.pressed:
			# Start dragging
			if corrupted:return
			is_dragging = true
			drag_offset = get_global_mouse_position() - global_position
			z_index = 100
		else:
			if corrupted:return
			# Mouse released
			is_dragging = false
			z_index = 0
			_check_drop()

	elif event is InputEventMouseMotion and is_dragging:
		if corrupted:return
		global_position = get_global_mouse_position() - drag_offset

func _check_drop():
	var dropped_in_zone := false

	# Suppose your drop zones are in a group called "drop_zone"
	for zone in get_tree().get_nodes_in_group("drop_zone"):
		if zone is Control and zone.get_global_rect().has_point(get_global_mouse_position()):
			mouse_filter = Control.MOUSE_FILTER_IGNORE
			dropped_in_zone = true
			anim.play("drop")
			break
	# hand._update_cards()
	SignalBus.update_hand.emit()
	if not dropped_in_zone:
		anim.play('RESET')
	# 	# Return to original position
	# 	var tween := create_tween()
	# 	tween.tween_property(self, "position", original_pos, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)


# func activate_card():
# 	if Global.energy - data.energy < 0: return

# 	is_activated = true
# 	highlight.show()
# 	SignalBus.activate_card.emit(self)
# 	Audio.play_random('sfx_ui_drop')

# func deactivate_card():
# 	is_activated = false
# 	highlight.hide()
# 	SignalBus.deactivate_card.emit(self)
# 	Audio.play_random('sfx_ui_pluck')

func generate_description():
	for activation in data.activations:
		card_description.text += activation.description + "\n"
		print(activation.description)

func _on_close_pressed() -> void:
	Global.discard(self)
	SignalBus.update_hand.emit()

	if randf() < 0.1:
		var res = load("res://cards/resources/cards/SUPER_DELUXE.tres")
		Global.create_card(res)

func corrupt():
	$Container/info/corrupt.show()
	corrupted = true
