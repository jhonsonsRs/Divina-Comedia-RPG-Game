extends EnemyState
class_name BossDeath

func enter():
	enemy.velocity = Vector2.ZERO
	enemy.play_anim("Death")
	await enemy.anim.animation_finished
	enemy.queue_free()
	var game = get_node("/root/Mundo")
	if game:
		game.on_enemy_destroyed(enemy)
