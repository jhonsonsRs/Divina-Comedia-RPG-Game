extends BasicEnemyState

func enter():
	enemy.animation_tree["parameters/playback"].travel("idle")
	
func update(_delta):
	if enemy.velocity.length() > 2:
		enemy.state_machine.change_state(enemy.state_machine.get_node("Follow"))
