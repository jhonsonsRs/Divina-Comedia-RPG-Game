extends Quest
class_name Quest_Homero

var quest_id_string = "quest_homero"
var objective_text = ""
var versos_entregues : int = 0
var total : int = 3

func _init():
	self.quest_id = QuestManager.QuestID.QuestHomero
	objective_text = "Restaure os versos (0/" + str(total) + ")"
	
func on_quest_event(event_id : String):
	if event_id.begins_with("verso_"):
		versos_entregues += 1
		var root = Engine.get_main_loop().root
		if root.has_node("Mundo"):
			var game = root.get_node("Mundo")
			game.update_quest_ui("Restaure os versos (" + str(versos_entregues) + "/3)")
		else:
			printerr("Erro: Nó 'Mundo' não encontrado ao iniciar a quest.")
		
		if versos_entregues >= total:
			GameState.mark_quest_complete("quest_homero")
			QuestManager.on_quest_finished()
