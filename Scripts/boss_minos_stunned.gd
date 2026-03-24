extends EnemyState

var tail_shape : CollisionShape2D
var tail : Area2D
var hurtbox_shape : CollisionShape2D 

func enter():
	self.tail_shape = enemy.tail_shape
	self.tail = enemy.tail
	self.hurtbox_shape = enemy.hurtbox_shape
	hurtbox_shape.disabled = false
	tail_shape.disabled = true
	await get_tree().create_timer(3.0).timeout
	enemy.state_machine.change_state(enemy.state_machine.get_node("Idle"))

func exit():
	tail_shape.disabled = false
	hurtbox_shape.disabled = true
	tail.position = Vector2(0, 0)
