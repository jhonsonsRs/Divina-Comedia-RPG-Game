extends Quest
class_name Quest_ExploreNivel2

var quest_id_string := "explore_nivel_2"
var objective_text := "Explore o nível 2 do castelo"

func _init():
	self.quest_id = QuestManager.QuestID.ExploreNivel2
	
func on_dialogue_finished(npc_id: String) -> void:
	if npc_id == "heraclito":
		GameState.mark_quest_complete(quest_id_string)
		QuestManager.on_quest_finished()
		var root = Engine.get_main_loop().root
		if root.has_node("Mundo"):
			var game = root.get_node("Mundo")
			game.teleportar_dimensional("arena_alexandre", "SpawnPlayer")
