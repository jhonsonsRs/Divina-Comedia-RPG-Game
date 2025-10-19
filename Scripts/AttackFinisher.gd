extends State
class_name AttackFinisher

@export var attack_animation_name: String = "attack4"
@export var attack_duration: float = 0.6 
@export var lunge_speed: float = 120.0
@export var lunge_friction: float = 0.08

# --- NOVA VARIÁVEL ---
# Define quando o jogador pode "enfileirar" o próximo ataque
@export var buffer_window_start: float = 0.3
var attack_buffered: bool = false # Guarda o clique para o próximo combo

var timer: float = 0.0

func enter():
	timer = 0.0
	attack_buffered = false # Reseta o buffer
	
	player.velocity = player.last_direction * lunge_speed
	player.animation_tree["parameters/playback"].travel(attack_animation_name)
	player.animation_tree["parameters/" + attack_animation_name + "/blend_position"] = player.last_direction

func update(delta):
	timer += delta
	player.velocity = player.velocity.lerp(Vector2.ZERO, lunge_friction)

	# Quando a animação do FINALIZADOR terminar...
	if timer >= attack_duration:
		
		# Verificamos: O jogador apertou o botão (quer recomeçar o combo)?
		if attack_buffered:
			# SIM! Reseta o combo_step para 1 e vai direto para o Attack1
			player.combo_step = 1
			player.state_machine.change_state(player.state_machine.get_node("Attack1"))
		else:
			# NÃO! O jogador não apertou. Reseta o combo e vai para Idle.
			player.combo_step = 0
			player.state_machine.change_state(player.state_machine.get_node("Idle"))

# --- FUNÇÃO ADICIONADA ---
# Esta é a função chamada por Player.gd
func register_attack_press():
	# Se o jogador apertar o botão durante a janela de buffer...
	if timer >= buffer_window_start:
		# ...guardamos o clique!
		attack_buffered = true
