extends Node2D
class_name ItemChave

@export var item_id : String = ""
@onready var interaction_icon : Sprite2D = $Icon

var player_ref : CharacterBody2D = null
var player_in_range := false
@onready var _sprite : Sprite2D = $Sprite2D
@onready var game_manager = get_node_or_null("/root/Mundo")

func _ready():
	if GameState.is_active(item_id):
		queue_free()
		return
	var tween = create_tween().set_loops()
	tween.tween_property(_sprite, "modulate", Color(1.5, 1.5, 1.5), 0.8)
	tween.tween_property(_sprite, "modulate", Color.WHITE, 0.8)
	
func _process(delta: float) -> void:
	if player_in_range and Input.is_action_just_pressed("Interact"):
		coletar_item()

func coletar_item():
	GameState.mark_collected(item_id)
	game_manager.on_item_collected(item_id)
	queue_free()

func _on_area_2d_body_entered(body) -> void:
	if body.is_in_group("Player"):
		player_in_range = true
		interaction_icon.visible = true

func _on_area_2d_body_exited(body) -> void:
	if body.is_in_group("Player"):
		player_in_range = false
		interaction_icon.visible = false
