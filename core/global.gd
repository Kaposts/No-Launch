extends Node

const SCENE_PATHS: Dictionary[String, String] = {
	"navigator_component" : "uid://brbg6i0mvo0l8",
}

const GROUP_DROP_ZONE = "drop_zone"


func _ready() -> void:
	SceneManager.transition_finished.connect(func(): print('Transition complete'))
	SceneManager.fade_complete.connect(func(): print('Fade complete'))

func transition():
	SceneManager.fade_out()
	await SceneManager.fade_complete
	SceneManager.fade_in()
