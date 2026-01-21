extends EnemyState

func enter():
	if enemy == null:
		return
	enemy.velocity = Vector2.ZERO
	enemy.animation_tree["parameters/playback"].travel("attack")
	get_tree().create_timer(0.6).timeout.connect(_end_attack)

func _end_attack():
	enemy.start_attack_cooldown(1.0)
	enemy.state_machine.change_state(enemy.state_machine.get_node("Idle"))
