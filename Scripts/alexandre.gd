extends CharacterBody2D

var player_ref : Player = null
var player_in_range: bool = false
var can_interact: bool = true
var encerrar_dialogo : bool = false
var can_start_dialog : bool = true
@onready var icon : Sprite2D = $Sprite2D2

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and player_in_range and encerrar_dialogo == false:
		can_interact = false
		icon.visible = false
		GameState.game_paused = true
		var lanterna = GameState.get_items_by_type("lanterna")
		if lanterna.is_empty():
			Dialogic.start("alexandre_dialog")
		else:
			Dialogic.start("alexandre_dialog_2")
			encerrar_dialogo = true
			GameState.remove_item("lanterna_diogenes")
			#dar a pedra
		if not Dialogic.timeline_ended.is_connected(_on_dialog_finished_enable_interaction):
				Dialogic.timeline_ended.connect(_on_dialog_finished_enable_interaction)
				
func _on_dialog_finished_enable_interaction() -> void:
	can_interact = true
	if player_in_range:
		icon.visible = true
	GameState.game_paused = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		player_ref = body
		player_in_range = true
		if can_interact:
			icon.visible = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		player_ref = null
		player_in_range = false
		icon.visible = false
