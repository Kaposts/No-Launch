extends State

func _ready():
    SignalBus.start_round.connect(_on_start_round)

func _on_start_round():
    change_state(target.BATTLE)

func _on_enter(_args) -> void:
    print("Idle")

