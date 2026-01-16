extends CSAction
class_name CSAction_WaitForSignal

var signal_name: String = ""

func play(player: Node) -> void:
	if signal_name == "":
		return
	print("Cutscene: Esperando sinal do Dialogic -> ", signal_name)
	
	while true:
		var received_arg = await Dialogic.signal_event
		if received_arg == signal_name:
			print("Cutscene: Sinal recebido! Continuando...")
			break
