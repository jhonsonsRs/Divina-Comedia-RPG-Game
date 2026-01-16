extends Quest
class_name Quest_ChegueAteCastelo

var quest_id_string := "chegue_ate_castelo"
var objective_text := "Avance até o castelo"

func _init():
	self.quest_id = QuestManager.QuestID.ChegueAteCastelo

func on_zone_entered(zone_id):
	if zone_id == "chegou_castelo":
		GameState.mark_quest_complete(quest_id_string)
		QuestManager.on_quest_finished()
