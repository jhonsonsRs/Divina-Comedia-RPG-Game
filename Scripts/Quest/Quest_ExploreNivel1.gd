extends Quest
class_name Quest_ExploreNivel1

var quest_id_string := "explore_nivel_1"
var objective_text := "Explore o nível 1 do castelo"

func _init():
	self.quest_id = QuestManager.QuestID.ExploreNivel1
	
func on_dialogue_finished(npc_id: String) -> void:
	if npc_id == "homero_dialog_1":
		GameState.mark_quest_complete(quest_id_string)
		QuestManager.on_quest_finished()
		var root = Engine.get_main_loop().root
		if root.has_node("Mundo"):
			var game = root.get_node("Mundo")
			game.teleportar_dimensional("ValeDosHerois", "SpawnPlayer")
