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
	#SO THAT WHEN DRAWING YOU CAN'T RUIN CARDS POSITION
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	anim.play(ANIM_DRAW)

	anim.animation_finished.connect(_on_anim_finished)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	# gui_input.connect(_on_gui_input)

	card_background.texture = data.background
	card_sprite.texture = data.sprite
	card_name.text = data.name
	card_description.text = data.description

func _on_anim_finished(anim_name: StringName):
	if anim_name == ANIM_DRAW:
		mouse_filter = Control.MOUSE_FILTER_STOP
	if anim_name == ANIM_DROP:
		hand.discard(self)

func _on_mouse_entered():
	is_hovered = true
	if not is_dragging:
		anim.play(ANIM_ENTER)

func _on_mouse_exited():
	is_hovered = false
	if not is_dragging:
		anim.play(ANIM_EXIT)



# func _on_gui_input(event: InputEvent) -> void:
# 	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
# 		if event.pressed:
# 			is_dragging = true
# 			drag_offset = get_global_mouse_position() - global_position
# 			z_index = 100
# 		else:
# 			is_dragging = false
# 			z_index = 4
# 			_check_drop()
# 	elif event is InputEventMouseMotion and is_dragging:

# 		global_position = get_global_mouse_position() - drag_offset

# func _check_drop():
# 	var dropped_in_zone := false

# 	for zone in get_tree().get_nodes_in_group(Global.GROUP_DROP_ZONE):
# 		if zone is Control and zone.get_global_rect().has_point(get_global_mouse_position()):
# 			dropped_in_zone = true
# 			print(dropped_in_zone)
# 			mouse_filter = Control.MOUSE_FILTER_IGNORE
# 			anim.play(ANIM_DROP)
# 			break

# 	if not dropped_in_zone:
# 		get_parent()._update_cards()
# 		anim.play(ANIM_EXIT)


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if is_activated: deactivate_card()
			else: activate_card()

func activate_card():
	is_activated = true
	highlight.show()
	SignalBus.activate_card.emit(self)

func deactivate_card():
	is_activated = false
	highlight.hide()
	SignalBus.deactivate_card.emit(self)
