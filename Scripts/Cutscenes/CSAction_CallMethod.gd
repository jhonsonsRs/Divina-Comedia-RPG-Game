extends CSAction
class_name CSAction_CallMethod

var group_name : String
var method_name : String

func play(cutscene_player: Node) -> void:
	cutscene_player.get_tree().call_group(group_name, method_name)
