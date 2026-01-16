extends Quest
class_name Quest_CaminheComVirgilio

var quest_id_string := "caminhe_com_virgilio"
var objective_text := "Caminhe com Virgílio através do Bosque"

func _init():
	self.quest_id = QuestManager.QuestID.CaminheComVirgilio

func on_zone_entered(zone_id : String):
	if zone_id == "zona_batalha_tutorial":
		GameState.mark_quest_complete(quest_id_string)
		QuestManager.on_quest_finished()
