extends CSAction
class_name CSAction_CallMethod

var node : Node
var method_name : String

func play(cutscene_player: Node) -> void:
	if node and node.has_method(method_name):
		node.call(method_name)
