extends Node
class_name Quest

var quest_id : int
var game_manager = get_node_or_null("root/Mundo")

func on_enemy_destroyed(enemy: Node2D) -> void:
	pass

func on_map_changed(previous_map_name: String, new_map_name: String) -> void:
	pass

func on_dialogue_finished(npc_id: String) -> void:
	pass

func on_zone_entered(zone_id: String) -> void:
	pass

func on_item_collected(_item_id: String) -> void:
	pass
	
func interact_items(_item_id: String) -> void:
	pass
