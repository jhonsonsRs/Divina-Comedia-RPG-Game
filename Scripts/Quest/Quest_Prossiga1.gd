extends Quest
class_name Quest_Prossiga1

var quest_id_string = "prossiga_1"
var objective_text = "Prossiga"

func _init():
	self.quest_id = QuestManager.QuestID.Prossiga1

func on_zone_entered(zone_id):
	if zone_id == "zona_boss_battle":
		GameState.is_quest_complete(quest_id_string)
		QuestManager.on_quest_finished()
