extends EnemyState
class_name BossAttack

@export var attack_duration := 3.0
@export var cooldown: float = 0

func enter():
	enemy.velocity = Vector2.ZERO
	enemy.play_anim("Attack") 
	await enemy.anim.animation_finished
	if cooldown > 0:
		await enemy.get_tree().create_timer(cooldown).timeout

	# Volta para a perseguição
	if is_instance_valid(enemy) and not enemy.is_dead:
		enemy.state_machine.change_state(enemy.state_machine.get_node("Chase"))
