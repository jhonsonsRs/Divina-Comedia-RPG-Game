extends EnemyState

func enter() -> void:
	enemy.sprite.modulate = Color(0.5, 0.5, 1) 

	var knockback_dir = -enemy.dash_direction
	enemy.velocity = knockback_dir * 200
	enemy.move_and_slide()
	
	enemy.state_timer.start(2.0) 
	enemy.state_timer.timeout.connect(_on_timeout)

func exit() -> void:
	enemy.state_timer.timeout.disconnect(_on_timeout)

func _on_timeout() -> void:
	get_parent().change_state(get_node("../Follow"))
