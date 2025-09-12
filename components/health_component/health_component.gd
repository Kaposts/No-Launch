class_name HealthComponent
extends Node
## Health Component
##
## Health Component to manages a character's HP

signal died
signal health_changed(change_value: float)


@export var max_health: float = 10.0
var current_health: float


#===================================================================================================
#region BUILT-IN VIRTUAL FUNCTIONS

func _ready() -> void:
	current_health = max_health


#endregion
#===================================================================================================
#region PUBLIC FUNCTIONS
func damage(damage_amount: float) -> void:
	heal(-damage_amount)
	Callable(check_death).call_deferred() #call the check death function in an idle frame


func heal(heal_amount: float) -> void:
	current_health = clamp(current_health + heal_amount, 0.0, max_health)
	health_changed.emit(heal_amount)


func get_health_percent() -> float:
	if max_health <= 0.0:
		return 0.0
	return min(current_health / max_health, 1.0)


func check_death() -> void:
	if current_health <= 0.0:
		died.emit()
		owner.queue_free()

#endregion
