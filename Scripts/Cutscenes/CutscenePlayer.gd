extends Node
class_name CutscenePlayer

signal cutscene_finished
var actions: Array = []

func play_cutscene():
	if actions.is_empty():
		return
	GameState.game_paused = true
	await _run_actions()
	GameState.game_paused = false
	actions.clear()
	if actions.is_empty():
		emit_signal("cutscene_finished")

func _run_actions() -> void:
	for action in actions:
		await action.play(self)
