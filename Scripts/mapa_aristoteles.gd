extends Node2D

@onready var limit_tl = $limit_tl
@onready var limit_br = $limit_br

@export var cena_pedra_natureza : PackedScene
@export var cena_pedra_razao : PackedScene
@export var cena_pedra_ato : PackedScene
@export var cena_chave : PackedScene
@onready var marker_spawn_1: Marker2D = $MarkerPedraNatureza
@onready var marker_spawn_2: Marker2D = $MarkerPedraRazao
@onready var marker_spawn_3: Marker2D = $MarkerPedraAto
@onready var marker_spawn_chave : Marker2D = $MarkerChave

func _ready() -> void:
	GameState.maquina_consertada.connect(_spawnar_pedra_natureza)
	GameState.balanca_equilibrada.connect(_spawnar_pedra_razao)
	GameState.lanterna_entregue.connect(_spawnar_pedra_ato)
	GameState.cryptex_liberado.connect(_spawnar_chave)
	var game_manager = get_node_or_null("/root/Mundo")
	game_manager.set_camera_limit(limit_tl.global_position, limit_br.global_position)

func _spawnar_chave():
	var nova_chave = cena_chave.instantiate()
	nova_chave.global_position = marker_spawn_chave.global_position
	call_deferred("add_child", nova_chave)

func _spawnar_pedra_natureza() -> void:
	var nova_pedra = cena_pedra_natureza.instantiate()
	nova_pedra.global_position = marker_spawn_1.global_position
	call_deferred("add_child", nova_pedra)

func _spawnar_pedra_razao() -> void:
	var nova_pedra = cena_pedra_razao.instantiate()
	nova_pedra.global_position = marker_spawn_2.global_position
	call_deferred("add_child", nova_pedra)
	
func _spawnar_pedra_ato()-> void:
	var nova_pedra = cena_pedra_ato.instantiate()
	nova_pedra.global_position = marker_spawn_3.global_position
	call_deferred("add_child", nova_pedra)
