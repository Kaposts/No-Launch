extends Node


@onready var round_start_sfx_player: RandomAudioPlayer = %RoundStartSFXPlayer
@onready var play_button: TextureButton = %PlayButton
@onready var energy_label: Label = %EnergyLabel
@onready var energy_group: Control = %EnergyGroup
@onready var options_menu: Control = %OptionsMenu
@onready var pause_menu: Control = %PauseMenu
@onready var death_menu: Control = %DeathMenu
@onready var vignette: CanvasLayer = $Vignette
@onready var input_stop_layer: CanvasLayer = $InputStopLayer # Stop player input when in transition


func _ready():
	SignalBus.update_energy.connect(_on_update_energy)
	SignalBus.update_hand.connect(_on_update_hand)
	SignalBus.round_effect_activate.connect(_on_round_effect_activate)
	SignalBus.round_effect_hide.connect(on_round_effect_hide)
	SignalBus.player_lost.connect(_on_player_lost)
	SignalBus.end_round.connect(_on_end_round)
	
	input_stop_layer.hide()
	
	play_button.pressed.connect(_on_play_turn_pressed)
	pause_menu.visibility_changed.connect(_on_menu_visibility_changed)
	death_menu.visibility_changed.connect(_on_menu_visibility_changed)
	options_menu.visibility_changed.connect(_on_menu_visibility_changed)


func _on_update_energy(value):
	energy_label.text = str(value) +"/"+ str(Global.max_energy)
func _on_update_hand():
	$cards_in_deck.text = "Cards insinde deck: " + str(Global.deck.size())

func _on_play_turn_pressed() -> void:
	Global.play_turn()
	round_start_sfx_player.play_random()
	play_button.disabled = true
	
	energy_group.modulate.a = 0.15
	play_button.hide()


func _on_end_round() -> void:
	play_button.disabled = false
	energy_group.modulate.a = 1.0
	play_button.show()


func on_round_effect_hide():
	$round_effect/AnimationPlayer.play("hide")

func _on_round_effect_activate(description: String):
	$round_effect.show()
	$round_effect/AnimationPlayer.play("show")
	$round_effect/BG/description.text = description

func _on_round_effect_close_pressed() -> void:
	$round_effect.hide()

func _input(event):
	if event is InputEventKey:
		if event.pressed and not event.echo:
			if event.keycode == KEY_ESCAPE:
				if death_menu.visible:
					pass
				elif pause_menu.visible or options_menu.visible:
					options_menu.hide()
					pause_menu.hide()
				else:
					pause_menu.show()
				get_viewport().set_input_as_handled()


# Prep the scene when in transition
func _set_in_transition() -> void:
	death_menu.hide()
	options_menu.hide()
	pause_menu.hide()
	input_stop_layer.show()


func _on_menu_pressed() -> void:
	_set_in_transition()
	await Global.transition()
	get_tree().change_scene_to_file("res://scenes/UI/MainMenu.tscn")
	SignalBus.start_game.emit()

func _on_settings_pressed() -> void:
	pause_menu.hide()
	options_menu.show()

func _on_restart_pressed() -> void:
	_set_in_transition()
	await Global.transition()
	get_tree().reload_current_scene()
	SignalBus.start_game.emit()
	Global.is_playing_turn = false

func _on_player_lost() -> void:
	death_menu.show()


func _on_menu_visibility_changed() -> void:
	vignette.visible = pause_menu.visible or death_menu.visible or options_menu.visible
