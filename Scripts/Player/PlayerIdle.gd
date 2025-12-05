extends State

func enter():
	#quando ele entra, ele toca a animação de idle 
	player.animation_tree["parameters/playback"].travel("idle")

func update(_delta : float):
	#verifica se ele esta andando, se está, ele muda pro estado de run
	if player.velocity.length() > 2:
		player.state_machine.change_state(player.state_machine.get_node("Run"))
