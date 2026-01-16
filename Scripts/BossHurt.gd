extends EnemyState
class_name BossHurt

func enter():
	enemy.velocity = enemy.knockback_vector

	await enemy.get_tree().create_timer(0.3).timeout

	if is_instance_valid(enemy) and not enemy.is_dead:
		enemy.state_machine.change_state(
			enemy.state_machine.get_node("Chase")
		)
