extends Area2D

@export var target_map_name : String 
@export var target_spawn_name : String

var game_manager = null

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	game_manager = get_node_or_null("/root/Mundo")
	if not game_manager:
		printerr("Portal.gd: não foi possivel encontrar o AutoLoad Main")

func _on_body_entered(_body):
	if _body.is_in_group("Player"):
		set_deferred("monitoring", false)
		game_manager.call_deferred("trocar_mapa", target_map_name, target_spawn_name)
