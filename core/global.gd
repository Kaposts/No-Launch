extends Node

func _ready() -> void:
	SceneManager.transition_finished.connect(func(): print('Transition complete'))
	SceneManager.fade_complete.connect(func(): print('Fade complete'))

func transition():
	SceneManager.fade_out()
	await SceneManager.fade_complete
	SceneManager.fade_in()