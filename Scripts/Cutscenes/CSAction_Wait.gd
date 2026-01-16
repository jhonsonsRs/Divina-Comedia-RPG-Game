extends CSAction
class_name CSAction_Wait

var time := 1.0

func play(player: Node) -> void:
	await player.get_tree().create_timer(time).timeout
