extends Node

var game_paused := false

var inventory : Array[ItemData] = []

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
	
func add_item(item : ItemData):
	inventory.append(item)

func remove_item(item_id : String):
	for i in inventory:
		if i.id == item_id:
			inventory.erase(i)
			return

func get_items_by_type(tipo : String) -> Array:
	var result := []
	for item in inventory:
		if item.tipo == tipo:
			result.append(item)
	return result
