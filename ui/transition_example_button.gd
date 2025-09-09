extends Button

func _on_pressed() -> void:
	print("Button: pressed")
	await Global.transition()
	print("transition: finished")
