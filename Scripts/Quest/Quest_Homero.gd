extends Quest
class_name Quest_Homero

var quest_id_string = "quest_homero"
var objective_text = "Encontre a chave"
var item_alvo_id := "chave_homero"

func _init():
	self.quest_id = QuestManager.QuestID.QuestHomero
	
func on_item_collected(_item_id):
	if _item_id == item_alvo_id:
		GameState.is_quest_complete(quest_id_string)
		QuestManager.on_quest_finished()
	var root = Engine.get_main_loop().root
	if root.has_node("Mundo"):
		var game = root.get_node("Mundo")
		game.teleportar_dimensional("castelo_nivel1", "Spawn")
