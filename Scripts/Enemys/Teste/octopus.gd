extends CharacterBody2D
class_name Octopus

var move_speed := 40.0
var stop_distance := 60.0
var acceleration : float = 0.4
var friction : float = 0.8
var last_direction: Vector2 = Vector2(0, 1)
var health := 10
@export var animation_tree : AnimationTree = null

@onready var state_machine = $StateMachine
@onready var detection_area: Area2D = $Area2D
@onready var hurtbox: Hurtbox = $Hurtbox
var player : CharacterBody2D = null
var player_perto : bool = false

func _ready() -> void:
	animation_tree.active = true
	hurtbox.hit_received.connect(_on_hit_received)

func _physics_process(_delta):
	_move()
	move_and_slide()
	_attack()

func _move():
	if state_machine.current_state.name.begins_with("Attack"):
		velocity = velocity.lerp(Vector2.ZERO, friction)
		return

	var target_velocity = Vector2.ZERO # Começa parado
	var direction = Vector2.ZERO

	if player_perto and is_instance_valid(player):
		var _dist = global_position.distance_to(player.global_position)
		direction = global_position.direction_to(player.global_position)
		target_velocity = direction * move_speed
			
	if target_velocity != Vector2.ZERO:
		last_direction = direction
		animation_tree["parameters/idle/blend_position"] = direction
		animation_tree["parameters/run/blend_position"] = direction
		animation_tree["parameters/attack/blend_position"] = direction
		velocity = velocity.lerp(target_velocity, acceleration)
	else:
		velocity = velocity.lerp(Vector2.ZERO, friction)

func _attack():
	if not (player_perto and is_instance_valid(player)):
		return
	var current_state_name = state_machine.current_state.name
	if current_state_name.begins_with("Attack"):
		return
	var dist_atual = global_position.distance_to(player.global_position)
	if dist_atual <= 30:
		state_machine.change_state(state_machine.get_node("Attack"))
		

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_perto = false
		player = null

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_perto = true
		player = body

func _on_hit_received(hitbox: Hitbox):
	var dano_recebido = hitbox.damage
	print("tomei dano po, sou o octopus  %s" % dano_recebido)
	health -= dano_recebido
	if health <= 0:
		queue_free()
		
