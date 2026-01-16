extends Node

var game_paused := false

var quest_completion := {
	"caminhe_com_virgilio": false,
	"batalha_tutorial" : false,
	"prossiga_1" : false,
	"kill_boss_guardian" : false,
	"chegue_ate_castelo" : false,
	"explore_nivel_1" : false,
	"quest_homero" : false
}

var items := {
	"chave_homero" : true
}

func is_active(id: String) -> bool:
	return items.get(id, true)
	
func mark_collected(id: String):
	items[id] = false

func is_quest_complete(id:String)-> bool:
	return quest_completion.get(id, false)
	
func mark_quest_complete(id:String)-> void:
	quest_completion[id] = true
