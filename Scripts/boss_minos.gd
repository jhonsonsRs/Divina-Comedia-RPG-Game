extends Node2D
var health_max : int = 100
var health : int = 100
var phase_2 : bool = false
var is_dead : bool = false
@onready var tail : Area2D = $Cauda
@onready var mouth_spawn : Marker2D = $BocaSpawn
@onready var state_machine : Node = $StateMachine
@onready var sprite_body : Sprite2D = $Corpo/Sprite2D
@onready var tail_sprite : Sprite2D = $Cauda/Sprite2D
@onready var tail_shape : CollisionShape2D = $Cauda/CollisionShape2D
@onready var hurtbox : Area2D = $Cauda/Hurtbox
@onready var hurtbox_shape : CollisionShape2D = $Cauda/Hurtbox/CollisionShape2D

func _ready() -> void:
	pass
	hurtbox.hit_received.connect(_on_hit_received)

func _on_hit_received(hitbox : Hitbox):
	if is_dead:
		return
	health -= hitbox.damage
	print("Boss tomou dano")
	if health <= (health_max / 2.0) and phase_2 == false:
		phase_2 = true
	if health <= 0:
		die()
	
func die():
	print("Boss morreu")
	queue_free()
