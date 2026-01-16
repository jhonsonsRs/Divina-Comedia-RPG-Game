extends Quest
class_name Quest_Acabou

var quest_id_string := "acabou"
var objective_text := "Acabou as quests"

func _init():
	self.quest_id = QuestManager.QuestID.Acabou
