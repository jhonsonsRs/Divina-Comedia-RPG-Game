extends Node
class_name EnemyStateMachine2
@export var enemy : CharacterBody2D
var current_state : BasicEnemyState

func _ready() :
	current_state = $Idle
	current_state.enter()
	
func _process(delta):
	if current_state: 
		current_state.update(delta)

func change_state(new_state: BasicEnemyState):
	if current_state == new_state:
		return
	current_state.exit()
	current_state = new_state
	current_state.enter()
