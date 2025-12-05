# Player.gd
extends CharacterBody2D
class_name Player

# Variáveis de Movimento
var move_speed : float = 140.0
var acceleration : float = 0.4
var friction : float = 0.8
var last_direction: Vector2 = Vector2(0, 1) # Começa olhando para baixo
var health : int = 100

# Exports
@export var animation_tree : AnimationTree = null

# Onreadys
@onready var state_machine = $FiniteStateMachine
@onready var hurtbox : Hurtbox = $Hurtbox
@onready var attack1 = $AttackSound1

#Qual etapa do combo está
var combo_step: int = 0

func _ready() -> void:
	animation_tree.active = true
	hurtbox.hit_received.connect(_on_hit_received)

func _physics_process(_delta: float) -> void:
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

func _on_hit_received(hitbox: Hitbox):
	var dano_recebido = hitbox.damage
	print("tomei dano po {dano_recebido}")
	health -= dano_recebido
	#quando adicionar: state_machine.change_state("Hurt")
