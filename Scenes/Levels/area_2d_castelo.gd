extends Area2D

@export var zone_id := "chegou_castelo"

func _on_body_entered(body: Node2D) -> void:
	var game = get_node("/root/Mundo")
	if body.is_in_group("Player"):
		if game:
			game.on_zone_entered(zone_id)
		GameState.game_paused = true
		Dialogic.start("despedida_virgilio")
		await Dialogic.timeline_ended
		GameState.game_paused = false
		game.virgilio_parar_de_seguir()
		queue_free()
