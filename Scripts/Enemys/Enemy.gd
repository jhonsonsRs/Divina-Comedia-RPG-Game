extends CharacterBody2D
class_name Enemy

@export var max_health : int = 30
@export var move_speed : float = 60.0
@export var acceleration : float = 0.1
@export var friction : float = 0.1
@export var attack_distance : float = 40.0
@export var stop_distance: float = 40.0
@export var animation_tree : AnimationTree
@export var state_machine : Node
@export var knockback_force: float = 200.0

var last_direction: Vector2 = Vector2(0, 1)
var current_health : int
var player : CharacterBody2D = null
var player_perto : bool = false
var pode_atacar : bool = true
var knockback_vector: Vector2 = Vector2.ZERO
var is_dead := false

@onready var hurtbox: Hurtbox = $Hurtbox
@onready var detection_area : Area2D = $DetectionArea
@onready var sprite : Sprite2D = $Sprite2D

func _ready() -> void:
	self.current_health = max_health
	self.animation_tree.active = true
	hurtbox.hit_received.connect(_on_hit_received)
	detection_area.body_entered.connect(_on_area_2d_body_entered)
	detection_area.body_exited.connect(_on_area_2d_body_exited)

func _physics_process(delta: float) -> void:
	if GameState.game_paused:
		velocity = Vector2.ZERO
		return
	if state_machine.current_state.has_method("_physics_process"):
		state_machine.current_state._physics_process(delta)
		return
	_calculate_movement()
	move_and_slide()
	_check_attack()

func _calculate_movement():
	if state_machine.current_state.name.begins_with("Attack"):
		velocity = velocity.lerp(Vector2.ZERO, friction)
		return
	var target_velocity = Vector2.ZERO
	if player_perto and is_instance_valid(player):
		var dist = global_position.distance_to(player.global_position)
		if dist > stop_distance and is_dead == false:
			var direction = global_position.direction_to(player.global_position)
			target_velocity = direction * move_speed
			last_direction = direction
			animation_tree["parameters/idle/blend_position"] = last_direction
			animation_tree["parameters/run/blend_position"] = last_direction
			animation_tree["parameters/attack/blend_position"] = last_direction
	velocity = velocity.lerp(target_velocity, acceleration)

func _check_attack():
	if not (player_perto and is_instance_valid(player) and pode_atacar):
		return
	
	if state_machine.current_state.name == "Attack":
		return
	
	var dist = global_position.distance_to(player.global_position)
	if dist <= attack_distance:
		pode_atacar = false
		state_machine.change_state(state_machine.get_node("Attack"))

func _on_hit_received(hitbox: Hitbox):
	var estado_atual = state_machine.current_state.name
	if estado_atual == "Hurt" || estado_atual == "Death":
		return
	current_health -= hitbox.damage
	print("Inimigo tomou %s de dano. Vida restante: %s" % [hitbox.damage, current_health])
	var dir = (global_position - hitbox.global_position).normalized()
	knockback_vector = dir * knockback_force
	if current_health <= 0:
		state_machine.change_state(state_machine.get_node("Death"))
		is_dead = true
	else:
		state_machine.change_state(state_machine.get_node("Hurt"))
	
func _die():
	var game = get_node("/root/Mundo")
	if game:
		game.on_enemy_destroyed(self)
	queue_free()
	

func _on_area_2d_body_entered(body: Node2D):
	if body.is_in_group("Player"):
		player_perto = true
		player = body

func _on_area_2d_body_exited(body: Node2D):
	if body.is_in_group("Player"):
		player_perto = false
		player = null

func start_attack_cooldown(time: float):
	await get_tree().create_timer(time).timeout;
	pode_atacar = true
