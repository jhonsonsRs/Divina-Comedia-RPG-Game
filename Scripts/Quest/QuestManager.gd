extends Node
class_name Quest_Manager

enum QuestID {
	CaminheComVirgilio,
	MateInimigos,
	Prossiga1,
	DerroteGuardiao,
	ChegueAteCastelo,
	ExploreNivel1,
	QuestHomero,
	ColeteChaveHomero,
	Acabou
}
var current_quest : Quest

var quest_types = {
	QuestID.CaminheComVirgilio : Quest_CaminheComVirgilio,
	QuestID.MateInimigos : Quest_MateAsAlmasTutorial,
	QuestID.Prossiga1 : Quest_Prossiga1,
	QuestID.DerroteGuardiao : Quest_DerroteGuardiao,
	QuestID.ChegueAteCastelo : Quest_ChegueAteCastelo,
	QuestID.ExploreNivel1 : Quest_ExploreNivel1,
	QuestID.QuestHomero : Quest_Homero,
	QuestID.ColeteChaveHomero : Quest_ColeteChaveHomero,
	QuestID.Acabou : Quest_Acabou
}

func _init() -> void:
	var start_quest_id = QuestID.CaminheComVirgilio
	current_quest = quest_types[start_quest_id].new()
	
func on_quest_finished() -> void:
	if current_quest == null:
		print("Nenhuma missão ativa para finalizar.")
		return
	
	var next_quest_id : QuestID = current_quest.quest_id + 1
	if quest_types.has(next_quest_id):
		self.current_quest = self.quest_types[next_quest_id].new()
		var game_manager = get_node_or_null("/root/Mundo")
		game_manager.on_quest_finished()
	else:
		print("Parabéns, você completou todas as missões!")
		self.current_quest = null

func start_quest(id: QuestID) -> void:
	if quest_types.has(id):

		current_quest = quest_types[id].new()
		print("Quest iniciada forçadamente: " + str(id))

		var game_manager = get_node_or_null("/root/Mundo")
		if game_manager:
			game_manager.update_quest_ui(current_quest.objective_text)
	else:
		printerr("Erro: Tentou iniciar uma Quest ID que não existe no dicionário: ", id)
