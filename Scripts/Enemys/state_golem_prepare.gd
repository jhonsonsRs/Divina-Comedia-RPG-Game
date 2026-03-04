extends EnemyState

func enter():
	enemy.velocity = Vector2.ZERO 
	enemy.sprite.modulate = Color(1, 0, 0)
	enemy.dash_direction = enemy.global_position.direction_to(enemy.player.global_position)
	enemy.state_timer.start(1.0)
	enemy.state_timer.timeout.connect(_on_timeout)

func exit() -> void:
	enemy.state_timer.timeout.disconnect(_on_timeout)

func _on_timeout() -> void:
	get_parent().change_state(get_node("../Dash"))
