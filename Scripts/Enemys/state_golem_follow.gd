extends EnemyState
func enter():
	enemy.sprite.modulate = Color(1, 1, 1)

func update(delta: float):
	if enemy.player == null:
		return
	var direction = enemy.global_position.direction_to(enemy.player.global_position)
	enemy.velocity = direction * enemy.speed
	enemy.move_and_slide()
	
	if enemy.global_position.distance_to(enemy.player.global_position) < 100:
		get_parent().change_state(get_node("../Prepare"))
