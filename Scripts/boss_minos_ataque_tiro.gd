extends EnemyState

@export var projetil : PackedScene
var sprite : Sprite2D
var qtde_tiros : int
var mouth_spawn : Marker2D

func enter():
	self.sprite = enemy.sprite_body
	self.mouth_spawn = enemy.mouth_spawn
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "modulate", Color.YELLOW, 1.0)
	tween.tween_property(sprite, "modulate", Color(1.0, 0.0, 0.0, 1.0), 1.0)
	await tween.finished
	sprite.modulate = Color.RED
	qtde_tiros = 3
	if enemy.phase_2 == true:
		qtde_tiros = 6
	for i in qtde_tiros:
		var projectil_instance = projetil.instantiate()
		projectil_instance.global_position = mouth_spawn.global_position
		get_tree().current_scene.add_child(projectil_instance)
		await get_tree().create_timer(0.3).timeout
	enemy.state_machine.change_state(enemy.state_machine.get_node("Idle"))
