extends BasicEnemyState

func enter():
	enemy.animation_tree["parameters/playback"].travel("attack")
	get_tree().create_timer(0.5).timeout.connect(voltar_para_idle)
	
func voltar_para_idle():
	# Função chamada pelo timer
	enemy.state_machine.change_state(enemy.state_machine.get_node("Idle"))
