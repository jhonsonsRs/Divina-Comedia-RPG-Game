extends EnemyState
class_name BossChase

func enter():
	pass

func update(delta):
	# Segurança básica
	if not enemy.player_ref:
		enemy.state_machine.change_state(enemy.state_machine.get_node("Idle"))
		return
	var dist = enemy.global_position.distance_to(enemy.player_ref.global_position)
	if dist <= enemy.attack_range:
		enemy.state_machine.change_state(enemy.state_machine.get_node("Attack"))
		return
	var dir = (enemy.player_ref.global_position - enemy.global_position).normalized()
	enemy.velocity = dir * enemy.move_speed
	enemy.play_anim("Idle")
