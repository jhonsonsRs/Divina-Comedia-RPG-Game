extends Quest
class_name Quest_ColeteChaveHeraclito

var objective_text := "Colete sua recompensa!"
var quest_id_string := "colete_chave_heraclito"

func _init():
	self.quest_id = QuestManager.QuestID.ColeteChaveHeraclito

func on_item_collected(_item_id):
	if _item_id == "key_heraclito":
		QuestManager.on_quest_finished()
		GameState.mark_quest_complete(quest_id_string)
		var root = Engine.get_main_loop().root
		if root.has_node("Mundo"):
			var game = root.get_node("Mundo")
			game.teleportar_dimensional("castelo_nivel2", "Spawn")
