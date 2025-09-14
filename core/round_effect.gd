# all of this code is trash cacuse time is ticking it has a better approach 100% need to REFACTOR

extends Node

var nexus_takes_double_damage: bool = false
var card_kill_robot_maybe: bool = false
var double_or_nothing: bool = false

func _ready():
	SignalBus.end_round.connect(_on_end_round)

func _on_end_round():
	SignalBus.round_effect_hide.emit()
	await get_tree().create_timer(2).timeout

	change_effect()
	
func change_effect():
	reset_effects()
	activate_effect(pick_random_effect())

func pick_random_effect() -> int:
	return Enum.ROUND_EFFECTS.values().pick_random()

func activate_effect(effect: Enum.ROUND_EFFECTS):
	var description: String = "404"
	print("ASLDIHAS:OFIHAS:    ", effect)
	match effect:
		Enum.ROUND_EFFECTS.NEXUS_TAKES_DOUBLE_DAMAGE:
			nexus_takes_double_damage = true
			description = "Damage to cores is doubled"
		Enum.ROUND_EFFECTS.CARD_KILL_ROBOT_MAYBE:
			card_kill_robot_maybe = true
			description = "Playing a card has a 1/3 chance to destroy your robot"
		Enum.ROUND_EFFECTS.DOUBLE_OR_NOTHING:
			double_or_nothing = true
			description = "50% chance that a card will either work twice, or not at all"
		Enum.ROUND_EFFECTS.CORRUPTION_DETECTED:
			Global.corrupt_cards()
			description = "Some of your cards got corrupted"
		Enum.ROUND_EFFECTS.BIG_UPDATE:
			Global.big_update()
			description = "Cards receive additional effects"


	SignalBus.round_effect_activate.emit(description)

func reset_effects():
	nexus_takes_double_damage = false
	card_kill_robot_maybe = false
	double_or_nothing = false
