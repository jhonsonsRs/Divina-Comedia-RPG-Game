extends Quest
class_name Quest_Heraclito

var quest_id_string := "quest_heraclito"
var objective_text := "Derrote as ondas. Mantenha o território."

func _init():
	self.quest_id = QuestManager.QuestID.QuestHeraclito
