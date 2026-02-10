extends CharacterBody2D
class_name Filosofo_NPC

var player_ref : Player = null
var player_in_range: bool = false
var can_interact: bool = true
var can_start_dialog : bool = true
@onready var icon : Sprite2D = $Sprite2D2
@export var npc_id : String = "homero_dialog_1"
@export var dialog_1 : String = "homero_dialog"
@export var dialog_2 : String = "homero_dialog_final"
@export var quest_necessaria : String = "colete_chave_homero"

@onready var anim_player = get_node_or_null("AnimationPlayer")
@onready var anim_tree = get_node_or_null("AnimationTree")


func _process(_delta: float) -> void:
	if can_start_dialog == false:
		can_interact = false
		icon.visible = false
	if Input.is_action_just_pressed("interact") and player_in_range and can_interact:
		if Dialogic.current_timeline != null:
			return
		can_interact = false
		icon.visible = false
		
		GameState.game_paused = true
		if GameState.is_quest_complete(quest_necessaria) == false:
			Dialogic.start(dialog_1)
		else:
			Dialogic.start(dialog_2)
			can_start_dialog = false
		if not Dialogic.timeline_ended.is_connected(_on_dialog_finished_enable_interaction):
			Dialogic.timeline_ended.connect(_on_dialog_finished_enable_interaction)

func _on_body_entered(_body) -> void:
	if _body is Player:
		player_ref = _body
		player_in_range = true
		if can_interact:
			icon.visible = true

func _on_body_exited(_body) -> void:
	if _body is Player:
		player_ref = null
		player_in_range = false
		icon.visible = false
		
func _on_dialog_finished_enable_interaction() -> void:
	can_interact = true
	if player_in_range:
		icon.visible = true
	var game_manager = get_node_or_null("/root/Mundo")
	game_manager.on_dialogue_finished(npc_id)
	GameState.game_paused = false

func handle_animation():
	if anim_player == null and anim_tree == null:
		return
	var is_moving = velocity.length() > 0.1
	if is_moving:
		if anim_tree:
			anim_tree.active = true 
			
	else:
		if anim_tree:
			anim_tree.active = false
		
		if anim_player:
			anim_player.play("Idle")
