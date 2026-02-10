extends Node2D
@onready var limit_tl = $limit_tl
@onready var limit_br = $limit_br

func _ready() -> void:
	var game_manager = get_node_or_null("/root/Mundo")
	game_manager.set_camera_limit(limit_tl.global_position, limit_br.global_position)
