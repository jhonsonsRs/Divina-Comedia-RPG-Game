extends CharacterBody2D
class_name BossGuardiao

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var aura_timer = $AuraTimer
@onready var sprite = $Sprite2D
@onready var state_machine = $StateMachine
@onready var hurtbox : Hurtbox = $Hurtbox
@onready var progress_bar = $UI/ProgressBar

@export var max_health := 100
@export var knockback_force := 100.0

var is_active = false
var current_health := 0
var knockback_vector := Vector2.ZERO
var is_dead := false
var move_speed = 40.0
var player_ref : Node2D = null
var acceleration = 10.0
var attack_range = 45.0
var slow_aplicado := false

func _ready():
	current_health = max_health
	progress_bar.value = max_health
	$AuraArea2D.body_entered.connect(_on_aura_entered)
	$AuraArea2D.body_exited.connect(_on_aura_exited)
	$AuraTimer.timeout.connect(_on_aura_timeout)
	hurtbox.hit_received.connect(_on_hit_received)
	player_ref = get_tree().get_first_node_in_group("Player")

func _physics_process(delta):
	if GameState.game_paused:
		return

	if knockback_vector.length() > 1:
		velocity = knockback_vector
		knockback_vector = knockback_vector.move_toward(Vector2.ZERO, 800 * delta)

	if not is_active:
		return

	move_and_slide()

func ativar_boss():
	is_active = true

func _on_aura_entered(body):
	if body.name == "Player":
		print("Boss: Player entrou na aura. Contando 3s...")
		aura_timer.start()

func _on_aura_exited(body):
	if body.name == "Player":
		aura_timer.stop()
		_remover_slow(body)

func _on_aura_timeout():
	if player_ref and $AuraArea2D.overlaps_body(player_ref):
		print("Boss: 3 segundos passaram! APLICANDO SLOW.")
		_aplicar_slow(player_ref)

func _aplicar_slow(player):
	if slow_aplicado:
		return
	slow_aplicado = true
	player.move_speed *= 0.5
	player.modulate = Color(0.5, 0.5, 1.2)

func _remover_slow(player):
	if not slow_aplicado:
		return
	slow_aplicado = false
	player.move_speed = player.normal_speed
	player.modulate = Color(1, 1, 1)
		

func _on_hit_received(hitbox: Hitbox):
	if is_dead :
		return
	current_health -= hitbox.damage
	progress_bar.value = current_health
	print("Boss tomou dano:", hitbox.damage, "Vida:", current_health)
	var dir = (global_position - hitbox.global_position).normalized()
	knockback_vector = dir * knockback_force
	_flash_dano()
	if current_health <= 0:
		is_dead = true
		state_machine.change_state(state_machine.get_node("Death"))
	else:
		state_machine.change_state(state_machine.get_node("Hurt"))

func olhando_para_esquerda() -> bool:
	if not player_ref:
		return false
	return player_ref.global_position.x < global_position.x

func play_anim(base_name: String):
	var anim_name = base_name + "_2" if olhando_para_esquerda() else base_name

	if anim.current_animation == anim_name:
		return

	anim.play(anim_name)

func _get_idle_anim() -> String:
	return "Idle_2" if olhando_para_esquerda() else "Idle"


func _flash_dano():
	sprite.modulate = Color(1, 0.4, 0.4)
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = Color(1, 1, 1)
