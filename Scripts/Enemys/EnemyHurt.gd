extends EnemyState

func enter():
	if enemy == null:
		return
	enemy.velocity = enemy.knockback_vector
	var animation_root = enemy.animation_tree.tree_root
	if animation_root.has_node("hurt"):
		enemy.animation_tree["parameters/playback"].travel("hurt")
		await get_tree().create_timer(0.4).timeout
	else: 
		_flash_white()
		await get_tree().create_timer(0.25).timeout
	if enemy.state_machine.current_state == self:
		enemy.state_machine.change_state(enemy.state_machine.get_node("Idle"))

func _physics_process(delta):
	if enemy == null:
		return
	# Aplica fricção forte para ele deslizar com o knockback e parar
	enemy.velocity = enemy.velocity.lerp(Vector2.ZERO, enemy.friction)
	enemy.move_and_slide()

func _flash_white():
	var tween = create_tween()
	tween.tween_property(enemy, "modulate", Color(10, 10, 10, 1), 0.05) # Brilha
	tween.tween_property(enemy, "modulate", Color(1, 1, 1, 1), 0.2)    # Volta ao normal
