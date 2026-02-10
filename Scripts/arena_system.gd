extends Node2D

@export_category("Configurações da arena")

@export_category("Configurações da Arena")
@export var radius_start: float = 250.0
@export var radius_min: float = 100.0
@export var radius_max: float = 350.0
@export var shrink_speed_base: float = 10.0
@export var expand_amount: float = 30.0

@export_group("Ondas e Inimigos")
@export var enemy_scene: PackedScene
@export var meteor_scene: PackedScene
@export var total_waves: int = 4

var current_radius: float
var is_quest_active: bool = false
var player: CharacterBody2D = null
var current_wave: int = 0

var wave_timer: float = 0.0   
var spawn_timer: float = 0.0    
var meteor_timer: float = 0.0
var player_base_speed: float = 0.0
var current_wave_duration: float = 30.0
var current_spawn_interval: float = 3.0
var current_shrink_speed: float
var spawn_meteors: bool = false

var enemies_alive: int = 0

@export var quest_to_finish_id: String = ""

@onready var spawners_container = $Spawners

func _ready():
	current_radius = radius_start
	var players = get_tree().get_nodes_in_group("Player")
	if players.size() > 0:
		player = players[0]
	start_arena() 

func _process(delta):
	if Input.is_action_just_pressed("avance"):
		win_arena()
	if not is_quest_active: return
	shrink_logic(delta)
	keep_player_inside()
	queue_redraw()
	process_wave_logic(delta)
	
func process_wave_logic(delta):
	if wave_timer > 0:
		wave_timer -= delta
		spawn_timer -= delta
		if spawn_timer <= 0:
			spawn_enemy()
			spawn_timer = current_spawn_interval 
		if spawn_meteors:
			meteor_timer -= delta
			if meteor_timer <= 0:
				spawn_meteor()
				meteor_timer = 2.0 
				
	elif wave_timer <= 0 and enemies_alive <= 0:
		start_next_wave()
	
func _draw():
	var ring_color = Color(1.0, 0.4, 0.0, 1.0)
	if current_radius < 150:
		ring_color = Color(1.0, 0.9, 0.0, 1.0)
	draw_circle(Vector2.ZERO, current_radius, Color(1.0, 0.5, 0.0, 0.1))
	draw_arc(Vector2.ZERO, current_radius, 0, TAU, 64, ring_color, 6.0)
	
func shrink_logic(delta):
	current_radius -= current_shrink_speed * delta
	if current_radius < radius_min: current_radius = radius_min

func start_arena():
	if not player: player = get_tree().get_first_node_in_group("Player")
	if player and "normal_speed" in player:
		player_base_speed = player.normal_speed
	else:
		player_base_speed = 140.0
	is_quest_active = true
	current_radius = radius_start
	current_wave = 0
	set_process(true)
	start_next_wave()

func start_next_wave():
	current_wave += 1
	if current_wave > total_waves:
		win_arena()
		return
	
	print("--- INICIANDO WAVE: ", current_wave, " ---")
	reset_modifiers() 
	
	match current_wave:
		1: 
			current_wave_duration = 20.0
			current_spawn_interval = 4.0
			print("Wave 1: Aquecimento.")
			
		2: 
			current_wave_duration = 30.0
			current_spawn_interval = 3.5
			print("Wave 2: Gravidade Aumentada.")
			if player: player.move_speed = player_base_speed * 0.5
			
		3: 
			current_wave_duration = 40.0
			current_spawn_interval = 3.0
			spawn_meteors = true
			print("Wave 3: Chuva de Fogo.")
			
		4:
			current_wave_duration = 45.0
			current_spawn_interval = 2.0 
			current_shrink_speed *= 2.0 
			print("Wave 4: Sobreviva ao Fluxo.")

	wave_timer = current_wave_duration
	spawn_timer = 0.5

func spawn_enemy():
	if not is_inside_tree() or enemy_scene == null: return
	
	var enemy = enemy_scene.instantiate()
	var spawn_points = spawners_container.get_children()
	enemy.global_position = spawn_points.pick_random().global_position
	
	# Aplica Debuff da Wave 2 (Inimigos lentos também)
	if current_wave == 2 and "move_speed" in enemy:
		enemy.move_speed *= 0.6
	
	# Setup padrão
	enemy.tree_exited.connect(_on_enemy_died)
	get_parent().call_deferred("add_child", enemy)
	
	if "player" in enemy: enemy.player = player
	if "player_perto" in enemy: enemy.player_perto = true
	
	# Incrementa contador
	enemies_alive += 1
	call_deferred("force_enemy_aggro", enemy)

func force_enemy_aggro(enemy_node):
	var state_machine = enemy_node.find_child("StateMachine")
	
	if state_machine:
		var state_node = state_machine.find_child("Run", true, false)
		if state_node == null:
			state_node = state_machine.find_child("Follow", true, false)
			
		if state_node:
			if state_machine.has_method("transition_to"):
				state_machine.transition_to(state_node.name) 
			elif state_machine.has_method("change_state"):
				state_machine.change_state(state_node)
		else:
			if state_machine.has_method("transition_to"):
				state_machine.transition_to("Run")

func spawn_meteor():
	if not is_inside_tree() or meteor_scene == null: return
	
	var meteor = meteor_scene.instantiate()
	get_parent().call_deferred("add_child", meteor)

	var random_angle = randf() * TAU
	var random_dist = randf() * (current_radius - 20) 
	var offset = Vector2(cos(random_angle), sin(random_angle)) * random_dist
	
	meteor.global_position = global_position + offset
	
func _on_enemy_died():
	if not is_quest_active: return
	expand_arena_logic()
	enemies_alive -= 1
	
func reset_modifiers():
	current_shrink_speed = shrink_speed_base
	spawn_meteors = false
	if player: player.move_speed = 140.0

func expand_arena_logic():
	current_radius += expand_amount
	if current_radius > radius_max: current_radius = radius_max

func win_arena():
	print("VITÓRIA DE HERÁCLITO!")
	is_quest_active = false
	set_process(false)
	queue_redraw()
	if quest_to_finish_id != "":
		GameState.mark_quest_complete(quest_to_finish_id)
		QuestManager.on_quest_finished()	
		print("Quest '%s' finalizada com sucesso!" % quest_to_finish_id)

func stop_arena():
	is_quest_active = false
	set_process(false)
	queue_redraw()


func keep_player_inside():
	if player == null : return
	var distance_to_center = player.global_position.distance_to(global_position)
	if distance_to_center > current_radius:
		var direction = (player.global_position - global_position).normalized()
		player.global_position = global_position + (direction * current_radius)
