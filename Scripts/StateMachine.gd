# StateMachine.gd
extends Node
class_name StateMachine

@export var player : Player
var current_state : State

func _ready() :
	# Começa no estado Idle
	current_state = $Idle
	current_state.enter()
	
func _process(delta):
	# a cada frame atualiza a missão
	if current_state: 
		current_state.update(delta)

func change_state(new_state: State):
	# se a nova tarefa é a mesma da atual, retorna
	if current_state == new_state:
		return
	
	#caso contrário, sai da tarefa atual e carrega a nova 
	current_state.exit()
	current_state = new_state
	current_state.enter()
