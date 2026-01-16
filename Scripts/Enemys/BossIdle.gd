extends EnemyState
class_name BossIdle

func enter():
	enemy.velocity = Vector2.ZERO
	enemy.play_anim("Idle")

func update(_delta):
	if enemy.player_ref:
		enemy.state_machine.change_state(enemy.state_machine.get_node("Chase"))
