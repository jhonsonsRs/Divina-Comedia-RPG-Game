extends Node
class_name EnemyStateMachine

@export var enemy: CharacterBody2D
var current_state: EnemyState

func _ready() -> void:
	call_deferred("_iniciar_maquina")
	
func _iniciar_maquina() -> void:
	if enemy == null:
		enemy = get_parent()
		
	for child in get_children():
		if child is EnemyState:
			child.enemy = enemy
			
	if has_node("Idle"):
		current_state = $Idle
		current_state.enter()

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.update(delta)

func change_state(new_state: EnemyState):
	if current_state == new_state:
		return
	if current_state:
		current_state.exit()
	current_state = new_state
	current_state.enter()
