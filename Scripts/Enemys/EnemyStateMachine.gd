extends Node
class_name EnemyStateMachine

@export var enemy: Enemy
var current_state: EnemyState

func _ready() -> void:
	for child in get_children():
		if child is EnemyState:
			child.enemy = enemy
			
	if has_node("Idle"):
		current_state = $Idle
		current_state.enter()

func change_state(new_state: EnemyState):
	if current_state == new_state:
		return
	if current_state:
		current_state.exit()
	current_state = new_state
	current_state.enter()
