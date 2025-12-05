extends Node2D
const MAPS := {
	"BosqueDasSombras1" = preload("res://Scenes/Levels/BosqueDasSombras1.tscn"),
	"BosqueDasSombras2" = preload("res://Scenes/Levels/BosqueDasSombras2.tscn"),
	"CasteloDosFilosofos" = preload("res://Scenes/Levels/CasteloDosFilosofos.tscn")
}

@onready var player: CharacterBody2D = $Player
@onready var virgilio : CharacterBody2D = $Virgilio
@onready var level_container: Node = $LevelContainer
@onready var fade_animator : AnimationPlayer = $FadeLayer/AnimationPlayer
@onready var camera : Camera2D = $Player/Camera2D

var current_level: Node = null

func _ready() -> void:
	trocar_mapa("BosqueDasSombras1", "SpawnInicial")

func set_camera_limit(marker_pos_1: Vector2, marker_pos_2: Vector2) -> void:
	camera.limit_left = min(marker_pos_1.x , marker_pos_2.x)
	camera.limit_top = min(marker_pos_1.y, marker_pos_2.y)
	camera.limit_right = max(marker_pos_1.x, marker_pos_2.x)
	camera.limit_bottom = max(marker_pos_1.y, marker_pos_2.y)


func trocar_mapa(map_name : String, spawn_name : String):
	if is_instance_valid(current_level):
		fade_animator.play("fade_out")
		await fade_animator.animation_finished
	if player.get_parent() != self:
		player.get_parent().remove_child(player)
		add_child(player)
	if virgilio.get_parent() != self:
		virgilio.get_parent().remove_child(virgilio)
		add_child(virgilio)

	if is_instance_valid(current_level):
		current_level.queue_free()
	
	if not MAPS.has(map_name):
		printerr("Mapa não encontrado")
		return
	
	current_level = MAPS[map_name].instantiate()
	level_container.add_child(current_level)
	var spawn_point = level_container.find_child(spawn_name, true, false)
	if not spawn_point:
		printerr("Spawn point não encontrado")
	else:
		player.global_position = spawn_point.global_position
	
	var ysort = current_level.find_child("YSort", true, false)  
	if ysort:
		remove_child(player)
		remove_child(virgilio)
		ysort.add_child(player)
		ysort.add_child(virgilio)
	else: 
		push_warning("O nivel não tem o nó ysort")

	fade_animator.play("fade_in")
