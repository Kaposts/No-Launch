extends Control

@export var steps: Array[Control] = []

var current_step := 0

func _ready():
    # Hide all steps except the first
    for i in range(steps.size()):
        steps[i].hide()
    
    show_step(0)

func _input(event):
    if event is InputEventMouseButton:
        if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
            next_step()

func show_step(index: int):
    if index < 0 or index >= steps.size():
        return
    
    # Hide current step if visible
    if steps[current_step].visible:
        hide_step(current_step)
    
    current_step = index
    var step = steps[index]
    step.modulate.a = 0.0  # start transparent
    step.visible = true

    # Tween fade-in
    var tween = get_tree().create_tween()
    tween.tween_property(step, "modulate:a", 1.0, 0.5)


func hide_step(index: int):
    var step = steps[index]
    if not step.visible:
        return
    
    var tween = get_tree().create_tween()
    tween.tween_property(step, "modulate:a", 0.0, 0.5)
    tween.tween_callback(Callable(step, "hide"))

    if current_step >= steps.size() -1:
        hide()

func next_step():
    if current_step < steps.size() - 1:
        show_step(current_step + 1)
    else: hide_step(current_step)


func previous_step():
    if current_step > 0:
        show_step(current_step - 1)
