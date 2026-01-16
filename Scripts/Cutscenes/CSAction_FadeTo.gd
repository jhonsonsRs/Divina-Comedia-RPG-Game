extends CSAction
class_name CSAction_FadeTo

var color_rect: ColorRect
var target_alpha := 1.0
var speed := 1.0

func play(player: Node) -> void:
	if not is_instance_valid(color_rect):
		return
	color_rect.visible = true
	
	var tween = player.create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS) 
	
	tween.tween_property(
		color_rect,
		"modulate:a",
		target_alpha,
		speed
	)
	await tween.finished
