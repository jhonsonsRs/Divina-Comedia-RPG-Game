extends CharacterBody2D
class_name Virgilio

var move_speed := 100.0
var stop_distance := 60.0
var acceleration : float = 0.4
var friction : float = 0.8
var can_follow_player = true
var ultima_posicao: Vector2 = Vector2.ZERO
var last_direction: Vector2 = Vector2(0, 1)
@export var animation_tree : AnimationTree = null
@onready var state_machine = $StateMachine
@onready var interaction_area = $InteractionArea
@onready var interaction_icon = $InteractionIcon

@export var player : CharacterBody2D
var player_perto : bool = false
var can_interact : bool = true
var player_ref: Player = null

func _ready() -> void:
	animation_tree.active = true
	Dialogic.process_mode = Node.PROCESS_MODE_ALWAYS

func _physics_process(_delta):
	var velocidade_real = (global_position - ultima_posicao) / _delta
	ultima_posicao = global_position
	if GameState.game_paused:
		if velocidade_real.length() > 10.0:
				animation_tree["parameters/playback"].travel("run")
				animation_tree["parameters/idle/blend_position"] = velocidade_real.normalized()
				animation_tree["parameters/run/blend_position"] = velocidade_real.normalized()
		else:
			animation_tree["parameters/playback"].travel("idle") 
		return 
	_move()
	move_and_slide()
	
func _move():
	var target_velocity = Vector2.ZERO
	var direction = Vector2.ZERO
	if can_follow_player == true:
		var dist = global_position.distance_to(player.global_position)
		if dist > stop_distance:
			direction = global_position.direction_to(player.global_position)
			target_velocity = direction * move_speed
			
	if target_velocity != Vector2.ZERO:
		last_direction = direction
		animation_tree["parameters/idle/blend_position"] = direction
		animation_tree["parameters/run/blend_position"] = direction
		velocity = velocity.lerp(target_velocity, acceleration)
	else:
		velocity = velocity.lerp(Vector2.ZERO, friction)

func _process(_delta: float):
	if Input.is_action_just_pressed("interact") and player_perto and can_interact:
		if Dialogic.current_timeline != null:
			return
		can_interact = false
		interaction_icon.visible = false
		GameState.game_paused = true
		Dialogic.start("tutorial_virgilio")
		get_viewport().set_input_as_handled()
		if not Dialogic.timeline_ended.is_connected(_on_dialog_finished_enable_interaction):
			Dialogic.timeline_ended.connect(_on_dialog_finished_enable_interaction)

func _on_interaction_area_body_entered(body: Node2D) -> void:
	if body is Player:
		player_ref = body
		player_perto = true
		if can_interact :
			interaction_icon.visible = false


func _on_interaction_area_body_exited(body: Node2D) -> void:
	if body is Player:
		player_ref = null
		player_perto = false
		interaction_icon.visible = false
	
func _on_dialog_finished_enable_interaction() -> void:
	GameState.game_paused = false
	can_interact = true
	if player_perto:
		interaction_icon.visible = false
	get_node_or_null("/root/Mundo").on_dialogue_finished("virgilio")
