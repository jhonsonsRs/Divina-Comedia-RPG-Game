extends CSAction
class_name CSAction_WaitForDialogEnd

func play(player: Node) -> void:
	if Dialogic.current_timeline != null:
		await Dialogic.timeline_ended
