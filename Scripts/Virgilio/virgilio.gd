extends CharacterBody2D
class_name Virgilio

var move_speed := 100.0
var stop_distance := 60.0
var acceleration : float = 0.4
var friction : float = 0.8
var can_follow_player = true
var last_direction: Vector2 = Vector2(0, 1)
@export var animation_tree : AnimationTree = null
@onready var state_machine = $StateMachine

@export var player : CharacterBody2D
var player_perto : bool = false

func _ready() -> void:
	animation_tree.active = true

func _physics_process(_delta):
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
