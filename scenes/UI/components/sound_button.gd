extends TextureButton

@onready var button_clicked_sfx_player: RandomAudioPlayer = $ButtonClickedSFXPlayer
@onready var button_hovered_sfx_player: RandomAudioPlayer = $ButtonHoveredSFXPlayer


func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	pressed.connect(_on_pressed)


func _on_mouse_entered() -> void:
	button_hovered_sfx_player.play_random()


func _on_pressed() -> void:
	button_clicked_sfx_player.play_random()
