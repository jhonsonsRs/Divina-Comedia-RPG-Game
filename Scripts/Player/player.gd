# Player.gd
extends CharacterBody2D
class_name Player

# Variáveis de Movimento
var move_speed : float = 140.0
var normal_speed : float = 140.0
var acceleration : float = 0.4
var friction : float = 0.8
var last_direction: Vector2 = Vector2(0, 1) # Começa olhando para baixo
var health : int = 100
var is_invincible: bool = false
var is_hurt : bool = false
@onready var camera := $Camera2D

# Exports
@export var animation_tree : AnimationTree = null
@export var knockback_force : float = 200.0
@export var invincibility_time : float = 1.0

# Onreadys
@onready var particles = $GPUParticles2D 
@onready var sprite = $Sprite2D
@onready var state_machine = $FiniteStateMachine
@onready var hurtbox : Hurtbox = $Hurtbox
@onready var attack1 = $AttackSound1

#Qual etapa do combo está
var combo_step: int = 0

func _ready() -> void:
	animation_tree.active = true
	normal_speed = move_speed

func _physics_process(_delta: float) -> void:
	if GameState.game_paused:
		velocity = Vector2.ZERO
		return
	if is_hurt:
		move_and_slide()
		velocity = velocity.lerp(Vector2.ZERO, 0.1)
		return
	_move() #calcula a velocidade com base no estado
	move_and_slide() #aplica a velocidade e colide
	attack() #verifica se o jogador quer atacar
	
func _move():
	#AQUI SE O JOGADOR ESTÁ EM QUALQUER ESTADO QUE COMEÇA COM "ATTACK" ELE NÃO SE MOVE
	if state_machine.current_state.name.begins_with("Attack"):
		return

	#Se não estiver atacando...
	var _direction : Vector2 = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	)
	
	if _direction != Vector2.ZERO:
		#Se o jogador está se movendo
		last_direction = _direction.normalized() #salva a ultima direção
		
		# Atualiza a direção de todas as animações
		animation_tree["parameters/idle/blend_position"] = _direction
		animation_tree["parameters/run/blend_position"] = _direction
		animation_tree["parameters/attack1/blend_position"] = _direction
		animation_tree["parameters/attack2/blend_position"] = _direction
		animation_tree["parameters/attack3/blend_position"] = _direction
		animation_tree["parameters/attack4/blend_position"] = _direction
		
		# Aplica aceleração
		velocity.x = lerp(velocity.x, _direction.normalized().x * move_speed, acceleration)
		velocity.y = lerp(velocity.y, _direction.normalized().y * move_speed, acceleration)
		return
		
	# Aplica atrito (friction) se estiver parado
	velocity.x = lerp(velocity.x, 0.0, friction)
	velocity.y = lerp(velocity.y, 0.0, friction)	

func attack():
	# Verifica se o botão de ataque foi pressionado
	if Input.is_action_just_pressed("attack"):
		var current_state_name = state_machine.current_state.name #pega o nome da tarefa atual
		
		# Se o estado atual é Idle ou Run e o combo está em 0...
		if (current_state_name == "Idle" or current_state_name == "Run") and combo_step == 0:
			combo_step = 1 # o estado do combo é 1
			#diz pra mudar pro estado Attack 1
			state_machine.change_state(state_machine.get_node("Attack" + str(combo_step))) 
		
		# Se não esta no estado Idle ou Run e esta em algum estado que começa com Attack...
		elif current_state_name.begins_with("Attack"):
			# Chama a função no estado de ataque atual para ele verificar o timing
			state_machine.current_state.register_attack_press()


func aplicar_knockback(direcao: Vector2):
	is_hurt = true
	velocity = direcao * knockback_force
	await get_tree().create_timer(0.2).timeout
	is_hurt = false 

func start_invincibility():
	is_invincible = true
	var tween = create_tween()
	tween.set_loops(10) 
	tween.tween_property(sprite, "modulate:a", 0.2, 0.1) 
	tween.tween_property(sprite, "modulate:a", 1.0, 0.1)
	await get_tree().create_timer(invincibility_time).timeout
	sprite.modulate.a = 1.0 
	is_invincible = false

func camera_shake():
	if not camera: return
	var forca_inicial: float = 4.0  
	var duracao_total: float = 0.4 
	var passos: int = 20
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	var tempo_por_passo = duracao_total / float(passos)

	for i in range(passos):
		var progresso_decay = 1.0 - (float(i) / float(passos))
		var forca_atual = forca_inicial * progresso_decay
		var offset_x = randf_range(-forca_atual, forca_atual)
		var offset_y = randf_range(-forca_atual, forca_atual)
		tween.tween_property(camera, "offset", Vector2(offset_x, offset_y), tempo_por_passo)
	tween.tween_property(camera, "offset", Vector2.ZERO, 0.1).set_trans(Tween.TRANS_LINEAR)
	
func toggle_teleport_fx(ativar: bool):
	if ativar:
		particles.emitting = true
		var tween = create_tween()
		tween.tween_property(sprite, "modulate", Color(3, 3, 3, 1), 1.5)
	else:
		particles.emitting = false
		var tween = create_tween()
		tween.tween_property(sprite, "modulate", Color.WHITE, 1.0)
		


func _on_hurtbox_hit_received(hitbox: Area2D) -> void:
	if is_invincible:
		return
	var dano_recebido = hitbox.damage
	health -= dano_recebido
	print("Tomei dano: ", dano_recebido, " | Vida restante: ", health)
	
	if health <= 0:
		pass
		#GameState.game_over()
	var enemy_pos = Vector2.ZERO
	if hitbox.owner:
		enemy_pos = hitbox.owner.global_position
	else:
		enemy_pos = hitbox.global_position
	
	var direcao_empurrao = (global_position - enemy_pos).normalized()
	aplicar_knockback(direcao_empurrao)
	camera_shake()
	start_invincibility()
