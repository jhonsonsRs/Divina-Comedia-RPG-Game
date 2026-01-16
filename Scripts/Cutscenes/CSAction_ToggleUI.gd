extends CSAction
class_name CSAction_ToggleUI

var mostrar : bool = true

func play(controller: Node):
	var mundo = controller.get_parent()
	if "ui_node" in mundo and mundo.ui_node:
		mundo.ui_node.visible = mostrar
