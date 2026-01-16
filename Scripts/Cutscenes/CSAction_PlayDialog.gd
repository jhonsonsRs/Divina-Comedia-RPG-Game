extends CSAction
class_name CSAction_PlayDialog

var timeline_name := ""
var wait_for_close : bool = true

func play(player: Node) -> void:
	if timeline_name == "":
		return
	
	Dialogic.start(timeline_name)
	if wait_for_close:
		await Dialogic.timeline_ended
