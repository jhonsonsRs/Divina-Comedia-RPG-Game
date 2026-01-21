extends Node2D
const MAPS := {
	"BosqueDasSombras1" = preload("res://Scenes/Levels/BosqueDasSombras1.tscn"),
	"BosqueDasSombras2" = preload("res://Scenes/Levels/BosqueDasSombras2.tscn"),
	"BosqueDasSombras3" = preload("res://Scenes/Levels/BosqueDasSombras3.tscn"),
	"CasteloMapa" = preload("res://Scenes/Levels/CasteloMapa.tscn"),
	"castelo_nivel1" = preload("res://Scenes/castelo_nivel1.tscn"),
	"ValeDosHerois" = preload("res://vale_dos_herois.tscn"),
	"TemploGregoHomero" = preload("res://Scenes/Levels/templo_grego_homero.tscn")
}

@onready var inventario = $UI/inventario
@onready var menu_verso = $UI/MenuEscolhaVerso
@onready var player: CharacterBody2D = $Player
@onready var virgilio : CharacterBody2D = $Virgilio
@onready var level_container: Node = $LevelContainer
@onready var fade_animator : AnimationPlayer = $FadeLayer/AnimationPlayer
@onready var camera : Camera2D = $Player/Camera2D
@onready var ui_node : CanvasLayer = $UI
@onready var intro_anim : AnimationPlayer = $IntroAnim
@onready var tela_preta : ColorRect = $CutsceneLayer/TelaPreta
@onready var cutscene_player: CutscenePlayer = $CutscenePlayer

var tutorial_scene = preload("res://Scenes/TutorialPopUp.tscn")

var virgilio_seguindo : bool = true
var current_level: Node = null
var quest_manager = QuestManager
var is_transitioning : bool = false

func _ready() -> void:
	var modo_teste : bool = true
	if modo_teste:
		configurar_teste_castelo()
	else:
		trocar_mapa("BosqueDasSombras1", "SpawnInicial", "VirgilioSpawn")
		#trocar_mapa("BosqueDasSombras3", "SpawnPlayer", "SpawnVirgilio")
		#iniciar_cutscene_intro()
		if QuestManager.current_quest:
			update_quest_ui(QuestManager.current_quest.objective_text)
		else:
			update_quest_ui("")

func _process(_delta):
	if Input.is_action_just_pressed("inventario"):
		inventario.toggle()

func configurar_teste_castelo():
	print("--- INICIANDO EM MODO DE TESTE: CASTELO ---")
	GameState.mark_quest_complete("caminhe_com_virgilio")
	GameState.mark_quest_complete("batalha_tutorial")
	GameState.mark_quest_complete("prossiga_1")
	GameState.mark_quest_complete("kill_boss_guardian")
	GameState.mark_quest_complete("chegue_ate_castelo")
	
	QuestManager.start_quest(QuestManager.QuestID.ExploreNivel1) 
	virgilio_parar_de_seguir() 
	trocar_mapa("castelo_nivel1", "SpawnPlayer", "")

func set_camera_limit(marker_pos_1: Vector2, marker_pos_2: Vector2) -> void:
	camera.limit_left = min(marker_pos_1.x , marker_pos_2.x)
	camera.limit_top = min(marker_pos_1.y, marker_pos_2.y)
	camera.limit_right = max(marker_pos_1.x, marker_pos_2.x)
	camera.limit_bottom = max(marker_pos_1.y, marker_pos_2.y)

func virgilio_parar_de_seguir():
	virgilio_seguindo = false
	virgilio.set_physics_process(false) 
	virgilio.set_process(false)
	virgilio.velocity = Vector2.ZERO

func virgilio_volta_a_seguir():
	virgilio_seguindo = true

func trocar_mapa(map_name : String, spawn_name : String, virgilio_spawn : String):
	if is_transitioning:
		return
	is_transitioning = true
	if is_instance_valid(current_level):
		fade_animator.play("fade_out")
		await fade_animator.animation_finished
	if player.get_parent() != self:
		player.get_parent().remove_child(player)
		add_child(player)
	if virgilio.get_parent() != self:
		virgilio.get_parent().remove_child(virgilio)
		add_child(virgilio)
	
	if virgilio_seguindo:
		virgilio.visible = true
		virgilio.set_process(true)
		virgilio.set_physics_process(true)
	else :
		virgilio.visible = false 
		virgilio.set_process(false)    
		virgilio.set_physics_process(false)
	
	if is_instance_valid(current_level):
		current_level.queue_free()
	
	if not MAPS.has(map_name):
		printerr("Mapa não encontrado")
		return
	
	current_level = MAPS[map_name].instantiate()
	level_container.add_child(current_level)
	
	var ysort = current_level.find_child("YSort", true, false)  
	if ysort:
		remove_child(player)
		ysort.add_child(player)
		if virgilio_seguindo:
			remove_child(virgilio)
			ysort.add_child(virgilio)
		
	else: 
		push_warning("O nivel não tem o nó ysort")
	
	var spawn_point = current_level.find_child(spawn_name, true, false)
	if not spawn_point:
		printerr("Spawn point não encontrado")
	else:
		player.global_position = spawn_point.global_position
	
	if virgilio_seguindo and virgilio_spawn != "":
		var v_spawn = current_level.find_child(virgilio_spawn, true, false)
		if v_spawn:
			virgilio.velocity = Vector2.ZERO
			virgilio.global_position = v_spawn.global_position
	

	fade_animator.play("fade_in")
	await fade_animator.animation_finished
	is_transitioning = false
	
func on_map_changed(previous_map: String, new_map: String) -> void:
	if previous_map.is_empty():
		return
	if QuestManager.current_quest and QuestManager.current_quest.has_method("on_map_changed"):
		QuestManager.current_quest.on_map_changed(previous_map, new_map)

func on_dialogue_finished(npc_id: String) -> void:
	if QuestManager.current_quest and QuestManager.current_quest.has_method("on_dialogue_finished"):
		QuestManager.current_quest.on_dialogue_finished(npc_id)

func on_quest_finished() -> void:
	print("Missão concluida! preparando a próxima")
	var proxima_quest = QuestManager.current_quest
	if proxima_quest:
		update_quest_ui(QuestManager.current_quest.objective_text)
	else:
		update_quest_ui("")

func update_quest_ui(objective_text: String)-> void:
	ui_node.update_quest_objective(objective_text)

func on_zone_entered(zone_id: String) -> void:
	if QuestManager.current_quest and QuestManager.current_quest.has_method("on_zone_entered"):
		QuestManager.current_quest.on_zone_entered(zone_id)

func on_item_collected(_item_id : String) -> void:
	if QuestManager.current_quest and QuestManager.current_quest.has_method("on_item_collected"):
		QuestManager.current_quest.on_item_collected(_item_id)

func on_enemy_destroyed(enemy) -> void:
	if QuestManager.current_quest and QuestManager.current_quest.has_method("on_enemy_destroyed"):
		QuestManager.current_quest.on_enemy_destroyed(enemy)

func on_quest_event(event_id : String):
	if QuestManager.current_quest and QuestManager.current_quest.has_method("on_quest_event"):
		QuestManager.current_quest.on_quest_event(event_id)

func iniciar_cutscene_intro():
	cutscene_player.actions.clear()
	tela_preta.visible = true
	tela_preta.modulate.a = 1.0
	
	var esconder_ui = CSAction_ToggleUI.new()
	esconder_ui.mostrar = false 
	
	var timer1 = CSAction_Wait.new()
	timer1.time = 2.0
	
	var playAudio1 = CSAction_PlayAudio.new()
	playAudio1.audio_player = $SoundTrovao1
	
	var timer2 = CSAction_Wait.new()
	timer2.time = 1.5
	
	var playAudio2 = CSAction_PlayAudio.new()
	playAudio2.audio_player = $SoundTrovao2
	
	var timer3 = CSAction_Wait.new()
	timer3.time = 3.0
	
	var revelar_jogo = CSAction_FadeTo.new()
	revelar_jogo.color_rect = tela_preta
	revelar_jogo.target_alpha = 0.0
	revelar_jogo.speed = 2.0 
	
	var timer4 = CSAction_Wait.new()
	timer4.time = 1.0
	
	var dialog = CSAction_PlayDialog.new()
	dialog.timeline_name = "tutorial_virgilio"
	dialog.wait_for_close = false 
	
	var esperar_sinal = CSAction_WaitForSignal.new()
	esperar_sinal.signal_name = "virgilio_aparece"
	
	var mover_virgilio = CSAction_MoveTo.new()
	mover_virgilio.character = virgilio
	mover_virgilio.marker_name = "destino_virgilio"
	mover_virgilio.duration = 2.0
	
	var esperar_fechar = CSAction_WaitForDialogEnd.new()
	
	var mostrar_ui = CSAction_ToggleUI.new()
	mostrar_ui.mostrar = true
	
	cutscene_player.actions.append(esconder_ui)
	cutscene_player.actions.append(timer1)
	cutscene_player.actions.append(playAudio1)
	cutscene_player.actions.append(timer2)
	cutscene_player.actions.append(playAudio2)
	cutscene_player.actions.append(timer3)
	cutscene_player.actions.append(revelar_jogo)
	cutscene_player.actions.append(timer4)
	cutscene_player.actions.append(dialog)
	cutscene_player.actions.append(esperar_sinal)
	cutscene_player.actions.append(mover_virgilio)
	cutscene_player.actions.append(esperar_fechar)
	if not cutscene_player.is_connected("cutscene_finished", _on_intro_finished):
		cutscene_player.cutscene_finished.connect(_on_intro_finished, CONNECT_ONE_SHOT)
	cutscene_player.actions.append(mostrar_ui)
	cutscene_player.play_cutscene()

func cutscene_tutorial():
	cutscene_player.actions.clear()
	tela_preta.visible = false
	
	var esconder_ui = CSAction_ToggleUI.new()
	esconder_ui.mostrar = false 
	
	var dialog = CSAction_PlayDialog.new()
	dialog.timeline_name = "tutorial_combate"
	dialog.wait_for_close = true
	
	var move_camera = CSAction_MoveCamera.new()
	move_camera.camera = player.camera
	move_camera.target = current_level.find_child("DestinoCamera")
	move_camera.tempo = 1.5
	move_camera.novo_zoom = Vector2.ZERO
	move_camera.esperar_terminar = true
	
	var timer = CSAction_Wait.new()
	timer.time = 1.5
	
	var move_camera_volta = CSAction_MoveCamera.new()
	move_camera_volta.camera = player.camera
	move_camera_volta.target = player
	move_camera_volta.tempo = 1.5
	move_camera_volta.novo_zoom = Vector2.ZERO
	move_camera_volta.esperar_terminar = true
	
	var mostrar_ui = CSAction_ToggleUI.new()
	mostrar_ui.mostrar = true
	
	cutscene_player.actions.append(esconder_ui)
	cutscene_player.actions.append(dialog)
	cutscene_player.actions.append(move_camera)
	cutscene_player.actions.append(timer)
	cutscene_player.actions.append(move_camera_volta)
	cutscene_player.actions.append(mostrar_ui)
	
	cutscene_player.play_cutscene()

func cutscene_boss_guardian():
	cutscene_player.actions.clear()
	var esconder_ui = CSAction_ToggleUI.new()
	esconder_ui.mostrar = false 
	
	var dialog = CSAction_PlayDialog.new()
	dialog.timeline_name = "tutorial_boss_battle_1"
	dialog.wait_for_close = true

	var mostrar_ui = CSAction_ToggleUI.new()
	mostrar_ui.mostrar = true	

	cutscene_player.actions.append(esconder_ui)
	cutscene_player.actions.append(dialog)
	cutscene_player.actions.append(mostrar_ui)
	
	cutscene_player.play_cutscene()

func exibir_tutorial_andar():
	var popup = tutorial_scene.instantiate()
	add_child(popup)

func _on_intro_finished():
	print("Intro acabou! Chamando tutorial...")
	exibir_tutorial_andar()

func teleportar_dimensional(novo_mapa: String, novo_spawn: String):
	print("Iniciando teleporte dimensional Clean...")
	GameState.game_paused = true
	player.toggle_teleport_fx(true)
	var shake_tween = create_tween()
	shake_tween.set_loops(20) 
	shake_tween.set_trans(Tween.TRANS_SINE) 

	for i in range(20):
		var forca = 1.0 + (i * 0.3) 
		var random_offset = Vector2(randf_range(-forca, forca), randf_range(-forca, forca))
		shake_tween.tween_property(camera, "offset", random_offset, 0.05)
		if i == 19:
			shake_tween.tween_property(camera, "offset", Vector2.ZERO, 0.1)

	await get_tree().create_timer(1.5).timeout
	if shake_tween: shake_tween.kill()
	camera.offset = Vector2.ZERO

	trocar_mapa(novo_mapa, novo_spawn, "") 
	await get_tree().create_timer(0.5).timeout
	
	player.toggle_teleport_fx(false)
	
	await get_tree().create_timer(0.5).timeout
	GameState.game_paused = false

func tremer_camera(intensidade := 6, duracao := 0.2):
	var tempo := 0.0
	var original_pos := camera.position
	while tempo < duracao:
		camera.position = original_pos + Vector2(
			randf_range(-intensidade, intensidade),
			randf_range(-intensidade, intensidade)
		)
		await get_tree().process_frame
		tempo += get_process_delta_time()
	camera.position = original_pos
