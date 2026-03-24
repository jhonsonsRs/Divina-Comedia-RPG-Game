extends EnemyState

var wait_timer_phase_1 : float = 3.0
var wait_timer_phase_2 : float = 1.5
var tail : Area2D
@onready var timer : Timer = $Timer

func enter():
	self.tail = enemy.tail
	if enemy.phase_2 == false:
		timer.start(wait_timer_phase_1)
	else:
		timer.start(wait_timer_phase_2)
		
func exit():
	timer.stop()

func _on_timer_timeout() -> void:
	var attack = randi() % 3
	if attack == 0:
		print("Ataque 1 (varredura)")
		enemy.state_machine.change_state(enemy.state_machine.get_node("AtaqueVarredura"))
	elif attack == 1:
		print("Ataque 2 (tiro)")
		enemy.state_machine.change_state(enemy.state_machine.get_node("AtaqueTiro"))
	else:
		print("Ataque 3 (esmagar)")
		enemy.state_machine.change_state(enemy.state_machine.get_node("AtaqueEsmagar"))
