extends EnemyState

func enter() -> void:
	enemy.sprite.modulate = Color(1, 0.5, 0)

func update(delta: float) -> void:
	var motion = enemy.dash_direction * enemy.dash_speed * delta
	var collision = enemy.move_and_collide(motion)
	
	if collision:
		var collider = collision.get_collider()
		if collider.is_in_group("caixa_de_vidro"):
			if collider.has_method("quebrar_pelo_golem"):
				collider.quebrar_pelo_golem()

		get_parent().change_state(get_node("../Stunned"))
