extends EnemyState

#Nunca use @onready para puxar coisas do enemy dentro de um Estado.
var tail : Area2D 
var tail_sprite : Sprite2D 
var sprite : Sprite2D

func enter():
	tail = enemy.tail
	tail_sprite = enemy.tail_sprite
	sprite = enemy.sprite_body
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "modulate", Color.YELLOW, 1.0)
	tween.tween_property(sprite, "modulate", Color(1.0, 0.0, 0.0, 1.0), 1.0)
	tween.tween_property(tail, "rotation_degrees", 90, 1.0)
	tween.tween_property(tail, "scale:x", 2.0, 1.0).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN)
	tail.position = Vector2(-200, tail.position.y+200)
	var timer_lunge = 1.0
	if enemy.phase_2 == true:
		timer_lunge = 0.5
	tween.tween_property(tail, "position", Vector2(200, tail.position.y), timer_lunge)
	await tween.finished
	sprite.modulate = Color.RED
	tail.position = Vector2(0, 0)
	enemy.state_machine.change_state(enemy.state_machine.get_node("Idle"))

func exit():
	var tween = get_tree().create_tween()
	tween.tween_property(tail, "rotation_degrees", 0, 1.0)
	tween.tween_property(tail, "scale:x", 1.0, 1.0).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
