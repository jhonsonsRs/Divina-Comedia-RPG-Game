extends Node2D

@onready var limit_tl = $limit_tl
@onready var limit_br = $limit_br
@export var cena_pedra_habito : PackedScene
@onready var marker_spawn: Marker2D = $MarkerPedraHabito

func _ready() -> void:
	GameState.caixa_quebrada.connect(_spawnar_pedra_habito)
	var game_manager = get_node_or_null("/root/Mundo")
	game_manager.set_camera_limit(limit_tl.global_position, limit_br.global_position)

func _spawnar_pedra_habito():
	var nova_pedra = cena_pedra_habito.instantiate()
	nova_pedra.global_position = marker_spawn.global_position
	call_deferred("add_child", nova_pedra)
