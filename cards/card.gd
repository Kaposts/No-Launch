extends Control
class_name Card

@onready var hand: Hand = get_parent()

@export var data: CardData
@export var anim: AnimationPlayer
const ANIM_DRAW = "draw"
const ANIM_ENTER = "enter"
const ANIM_DROP = "drop"
const ANIM_EXIT = "exit"

var is_hovered := false
var is_dragging := false
var is_activated := false
var drag_offset: Vector2

@onready var card_background = $Container/background
@onready var card_sprite = $Container/container/sprite
@onready var card_name = $Container/container/Name
@onready var card_description = $Container/container/Description
@onready var highlight = $Container/highlight

func _ready():
	#SO THAT WHEN DRAWING YOU CAN'T RUIN CARDS ROTTATION
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	anim.play(ANIM_DRAW)

	anim.animation_finished.connect(_on_anim_finished)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

	card_background.texture = data.background
	card_sprite.texture = data.sprite
	card_name.text = data.name
	
	generate_description()

func _on_anim_finished(anim_name: StringName):
	if anim_name == ANIM_DRAW:
		mouse_filter = Control.MOUSE_FILTER_STOP
	if anim_name == ANIM_DROP:
		hand.discard(self)

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

func _on_gui_input(event: InputEvent) -> void:
	if Global.is_playing_turn: return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if is_activated: deactivate_card()
			else: activate_card()

func activate_card():
	is_activated = true
	highlight.show()
	SignalBus.activate_card.emit(self)
	Audio.play_random('sfx_ui_drop')

func deactivate_card():
	is_activated = false
	highlight.hide()
	SignalBus.deactivate_card.emit(self)
	Audio.play_random('sfx_ui_pluck')

func generate_description():
	for activation in data.activations:
		card_description.text += activation.description + "\n"
		print(activation.description)
	
