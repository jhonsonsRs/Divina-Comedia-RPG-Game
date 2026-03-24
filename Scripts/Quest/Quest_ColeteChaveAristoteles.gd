extends Quest
class_name Quest_ColeteChaveAristoteles

var objective_text := "Colete sua recompensa!"
var quest_id_string := "colete_chave_aristoteles"

func _init():
	self.quest_id = QuestManager.QuestID.ColeteChaveAristoteles

func on_item_collected(_item_id):
	if _item_id == "key_aristoteles":
		QuestManager.on_quest_finished()
		GameState.mark_quest_complete(quest_id_string)
		var root = Engine.get_main_loop().root
		if root.has_node("Mundo"):
			var game = root.get_node("Mundo")
			game.teleportar_dimensional("castelo_nivel3", "Spawn")
