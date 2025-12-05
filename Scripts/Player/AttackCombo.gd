extends State
class_name AttackCombo

@export var attack_animation_name: String = "attack1" #aqui o nome da animação
@export var attack_duration: float = 0.6
@export var lunge_speed: float = 80.0
@export var lunge_friction: float = 0.1

@export var combo_window_start: float = 0.3 # Janela de combo começa
@export var combo_window_end: float = 0.5  # Janela de combo termina

var timer: float = 0.0 #é um relogio do ataque
var early_press_buffered: bool = false # Guarda se o jogador clicou cedo dms

#roda quando o ataque começa
func enter():
	#zera o relógio
	timer = 0.0
	early_press_buffered = false # Reseta o buffer
	player.attack1.play()
	#da um impulso no player
	player.velocity = player.last_direction * lunge_speed
	#aq fala pra ele ativar a animação com base no nome dela
	player.animation_tree["parameters/playback"].travel(attack_animation_name)
	player.animation_tree["parameters/" + attack_animation_name + "/blend_position"] = player.last_direction

func update(delta):
	timer += delta
	#aplica o atrito no lunge
	player.velocity = player.velocity.lerp(Vector2.ZERO, lunge_friction)

	# --- LÓGICA DE BUFFER ---
	# 1. O jogador apertou cedo demais
	# 2. E a janela de combo acabou de abrir
	if early_press_buffered and timer >= combo_window_start:
		# SUCESSO! Executa o combo no tempo mínimo (0.2s)
		# e passa para o próximo ataque
		player.combo_step += 1
		player.state_machine.change_state(player.state_machine.get_node("Attack" + str(player.combo_step)))
		return # Sai da função update, pois já mudamos de estado

	# --- LÓGICA DE FALHA ---
	# Se o relógio passou o tempo de ataque
	if timer >= attack_duration:
		#o jogador falhou no combo
		player.combo_step = 0
		player.state_machine.change_state(player.state_machine.get_node("Idle"))

# Esta é a função chamada por Player.gd
func register_attack_press():
	# 1. O botão foi pressionado ANTES da janela? (ex: 0.12s)
	if timer < combo_window_start:
		# Guarda o clique no buffer. O update() vai cuidar disso.
		early_press_buffered = true
		
	# 2. O botão foi pressionado DENTRO da janela? (ex: 0.3s)
	elif timer >= combo_window_start and timer <= combo_window_end:
		# SUCESSO! Muda de estado IMEDIATAMENTE.
		player.combo_step += 1
		player.state_machine.change_state(player.state_machine.get_node("Attack" + str(player.combo_step)))

	# 3. Se o jogador apertar DEPOIS da janela (ex: 0.55s), 
	#    nada acontece, e o combo vai falhar (o update() vai levar ao Idle).
