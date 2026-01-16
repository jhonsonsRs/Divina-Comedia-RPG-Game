extends EnemyState

func enter():
	enemy.velocity = enemy.knockback_vector
	enemy.hurtbox.set_deferred("monitorable", false)
	enemy.set_collision_layer_value(1, false) 
	enemy.set_collision_mask_value(1, false)
	
	var animation_root = enemy.animation_tree.tree_root
	
	if animation_root.has_node("death"):
		enemy.animation_tree["parameters/playback"].travel("death")
		await get_tree().create_timer(0.7).timeout
		
	else:
		_flash_fast()
		await get_tree().create_timer(0.5).timeout
	enemy._die()

func _physics_process(delta):
	enemy.velocity = enemy.velocity.lerp(Vector2.ZERO, enemy.friction)
	enemy.move_and_slide()

func _flash_fast():
	var tween = create_tween()
	for i in range(4):
		tween.tween_property(enemy, "modulate", Color(10, 0, 0, 1), 0.06)
		tween.tween_property(enemy, "modulate", Color(1, 1, 1, 1), 0.06)
