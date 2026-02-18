extends Quest
class_name Quest_Aristoteles

var quest_id_string := "quest_aristoteles"
var objective_text := "Resolva os 4 puzzles"

func _init():
	self.quest_id = QuestManager.QuestID.QuestAristoteles
