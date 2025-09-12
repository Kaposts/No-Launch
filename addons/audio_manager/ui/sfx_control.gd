@tool
extends BoxContainer
class_name SFXControl

var audioResource: AudioData

func set_resource(data: AudioData):
    audioResource = data
    $play.pressed.connect(_play_button_pressed) 

func set_name_label(str: String):
    $name.text = str

func set_volume_slider(value: float):
    $volume_container/Volume.value = value
    $volume_container/Label.text = "Volume:" + str(value) + " db"

func set_pitch_slider(value: float):
    $pitch_container/Pitch.value = value
    $pitch_container/Label.text = "Pitch:" + str(value)

func set_pitch_randomizer(value: bool):
    $pitch_randomizer.button_pressed = value

func _play_button_pressed():
    $AudioStreamPlayer.stream = audioResource.res_stream
    $AudioStreamPlayer.volume_db = audioResource.res_volume_db
    $AudioStreamPlayer.pitch_scale = audioResource.res_pitch_scale
    if audioResource.res_pitch_randomizer:
        var config = preload("res://addons/audio_manager/config/config.tres")
        var range = config.pitch_randomizer_range
        var rand := randf_range(-1 * range, range)
        $AudioStreamPlayer.pitch_scale += rand
    $AudioStreamPlayer.play()

func _on_volume_value_changed(value: float) -> void:
    $volume_container/Label.text = "Volume:" + str(value) + " db"
    audioResource.res_volume_db = value
    save()

func _on_pitch_value_changed(value: float) -> void:
    $pitch_container/Label.text = "Pitch:" + "%0.2f" % value
    audioResource.res_pitch_scale = value
    save()

func _on_pitch_randomizer_toggled(toggled_on:bool) -> void:
    audioResource.res_pitch_randomizer = toggled_on
    save()

func save():
    ResourceSaver.save(audioResource, audioResource.resource_path)

