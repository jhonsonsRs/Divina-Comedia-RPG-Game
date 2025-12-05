extends State

func enter():
	#toca a animação de correr
	player.animation_tree["parameters/playback"].travel("run")

func update(_delta: float):
	#se ele esta parado, muda pro estado de Idle
	if player.velocity.length() <= 2:
		player.state_machine.change_state(player.state_machine.get_node("Idle"))
