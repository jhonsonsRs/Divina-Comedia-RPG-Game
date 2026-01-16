extends Quest
class_name Quest_DerroteGuardiao

var quest_id_string = "kill_boss_guardian"
var objective_text = "Derrote o Guardião"

func _init():
	self.quest_id = QuestManager.QuestID.DerroteGuardiao
	var root = Engine.get_main_loop().root
	if root.has_node("Mundo"):
		var game = root.get_node("Mundo")
		game.cutscene_boss_guardian()
	
func on_enemy_destroyed(enemy):
	if enemy.is_in_group("BossGroup"):
		GameState.mark_quest_complete(quest_id_string)
		QuestManager.on_quest_finished()
		GameState.game_paused = true
		Dialogic.start("pos_boss")
		await Dialogic.timeline_ended
		GameState.game_paused = false
