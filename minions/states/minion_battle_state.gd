extends State

var target_enemy: Minion
var attack_timer: float = 0.0

func _on_enter(_args) -> void:
    print("battle")

func _on_update(delta: float) -> void:

    # Decrease attack timer
    if attack_timer > 0.0:
        attack_timer -= delta

    # 1. Check if we already have a target
    if target_enemy == null or not is_instance_valid(target_enemy):
        target_enemy = _get_random_enemy()

    # 2. If no enemy exists, change state (e.g., back to IDLE or VICTORY)
    if target_enemy == null:
        change_state(target.END) # or another state like WIN/WAIT
        return

    # 3. Move toward the target
    var dir = (target_enemy.global_position - target.global_position).normalized()
    target.global_position += dir * target.speed * delta

    # 4. Check attack range
    if target.global_position.distance_to(target_enemy.global_position) <= target.attack_range:
        _attack(target_enemy)


# --- Helpers ---
func _get_random_enemy() -> Minion:
    var enemies = get_tree().get_nodes_in_group(target.target_group)
    if enemies.is_empty():
        return null

    return enemies.pick_random()


func _attack(enemy: Minion) -> void:
    print("Attacking ", enemy.name)
    enemy.health_component.damage(target.damage)
    attack_timer = target.attack_cooldown 
    # optional: if you want a new target after killing one
    if enemy.health <= 0:
        target_enemy = _get_random_enemy()