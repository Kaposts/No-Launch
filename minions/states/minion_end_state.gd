extends State

var nexus

func _on_enter(_args) -> void:
    nexus = get_tree().get_first_node_in_group(target.target_nexus)
    
func _on_update(_delta: float) -> void:
    var dir = (nexus.global_position - target.global_position).normalized()
    target.global_position += dir * target.speed * _delta