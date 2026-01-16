extends StaticBody2D

var player_ref : Player = null
var player_in_range: bool = false
var can_interact: bool = true
@onready var icon : Sprite2D = $Sprite2D2

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact") and player_in_range and can_interact:
		if Dialogic.current_timeline != null:
			return
		can_interact = false
		icon.visible = false
		
		GameState.game_paused = true
		Dialogic.start("homero_dialog")
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
	game_manager.on_dialogue_finished("homero_dialog_1")
	GameState.game_paused = false
