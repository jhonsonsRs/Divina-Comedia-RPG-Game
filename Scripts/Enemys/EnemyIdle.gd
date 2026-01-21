extends EnemyState

func enter():
	if enemy == null:
		return
	enemy.animation_tree["parameters/playback"].travel("idle")
	
func update(_delta):
	if enemy.velocity.length() > 5:
		enemy.state_machine.change_state(enemy.state_machine.get_node("Run"))
