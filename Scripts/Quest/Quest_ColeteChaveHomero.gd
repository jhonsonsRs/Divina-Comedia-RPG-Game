extends Quest
class_name Quest_ColeteChaveHomero

var objective_text := "Colete sua recompensa!"
var quest_id_string := "colete_chave_homero"

func _init():
	self.quest_id = QuestManager.QuestID.ColeteChaveHomero

func on_item_collected(_item_id):
	if _item_id == "key_homero":
		QuestManager.on_quest_finished()
		GameState.mark_quest_complete(quest_id_string)
