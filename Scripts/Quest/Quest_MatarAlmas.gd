extends Quest
class_name Quest_MateAsAlmasTutorial

var quest_id_string := "batalha_tutorial"
var total_inimigos := 3
var inimigos_mortos := 0
var objective_text := ""

func _init():
	self.quest_id = QuestManager.QuestID.MateInimigos
	var root = Engine.get_main_loop().root
	if root.has_node("Mundo"):
		var game = root.get_node("Mundo")
		game.cutscene_tutorial()
	else:
		printerr("Erro: Nó 'Mundo' não encontrado ao iniciar a quest.")
	self.objective_text = "Derrote as almas (0/" + str(total_inimigos) + ")"

func on_enemy_destroyed(enemy):
	inimigos_mortos += 1
	var game = Engine.get_main_loop().root.get_node("Mundo")
	game.update_quest_ui("Derrote as Sombras (" + str(inimigos_mortos) + "/" + str(total_inimigos) + ")")
	if inimigos_mortos >= total_inimigos:
		GameState.game_paused = true
		Dialogic.start("finish_quest_sombras")
		await Dialogic.timeline_ended
		GameState.game_paused = false
		GameState.mark_quest_complete(quest_id_string)
		QuestManager.on_quest_finished()
		
