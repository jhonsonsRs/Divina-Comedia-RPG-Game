extends EnemyState

var player : CharacterBody2D
var tail : Area2D 
var tail_sprite : Sprite2D 
var sprite : Sprite2D
var acertou_player : bool = false

func enter():
	self.tail = enemy.tail
	self.tail_sprite = enemy.tail_sprite
	self.sprite = enemy.sprite_body
	self.player = get_tree().get_first_node_in_group("Player")
	if not tail.area_entered.is_connected(_checar_acerto):
		tail.area_entered.connect(_checar_acerto)
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "modulate", Color.BLUE_VIOLET, 1.0)
	tween.tween_property(sprite, "modulate", Color(1.0, 0.0, 0.0, 1.0), 1.0)
	await tween.finished
	sprite.modulate = Color.RED
	var player_position = player.global_position
	tail.global_position = Vector2(player_position.x, player_position.y - 300)
	await get_tree().create_timer(2.0).timeout
	var timer_lunge = 0.15
	if enemy.phase_2 == true:
		timer_lunge = 0.1
	var tween_ataque = get_tree().create_tween()
	tween_ataque.tween_property(tail, "global_position", Vector2(player_position), timer_lunge)
	await tween_ataque.finished
	await get_tree().create_timer(0.1).timeout
	tail.area_entered.disconnect(_checar_acerto)
	
	if acertou_player == true:
		print("Acertou o player com precisão!")
		await get_tree().create_timer(0.5).timeout
		tail.position = Vector2(0, -500) # Sobe a cauda
		enemy.state_machine.change_state(enemy.state_machine.get_node("Idle"))
		tail.position = Vector2(0, 0)
	else:
		print("RESULTADO: Errou feio!")
		enemy.state_machine.change_state(enemy.state_machine.get_node("Stunned"))
	
func exit():
	self.acertou_player = false

func _checar_acerto(area: Area2D):
	# Se o que a cauda encostou foi o Player...
	if area.owner and area.owner.is_in_group("Player"):
		acertou_player = true # Dispara a armadilha!
