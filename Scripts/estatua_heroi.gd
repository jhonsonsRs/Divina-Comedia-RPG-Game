extends StaticBody2D

@export var heroi_id : String
@export var verso_correto_id : String

var player_perto : bool = false

func _ready() -> void:
	$Area2D.body_entered.connect(_on_body_entered)
	$Area2D.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.is_in_group("Player"):
		player_perto = true

func _on_body_exited(body):
	if body.is_in_group("Player"):
		player_perto = false

func interagir():
	var versos = GameState.get_items_by_type("verso")
	if versos.is_empty():
		print("Você não tem versos")
		return
		
	var game = get_node("/root/Mundo")
	game.menu_verso.abrir(versos, self)

func _process(_delta):
	if player_perto and Input.is_action_just_pressed("interact"):
		interagir()
	if Input.is_action_just_pressed("leave"):
		var game = get_node("/root/Mundo")
		game.menu_verso.fechar()

func usar_verso(item : ItemData):
	GameState.game_paused = false
	if item.id == verso_correto_id:
		aceitar_verso(item)
	else:
		erro_verso()
		
func aceitar_verso(item):
	GameState.remove_item(item.id)
	var game = get_node("/root/Mundo")
	game.on_quest_event("verso_" + heroi_id)
	efeito_acerto()
	
func erro_verso():
	print("Verso errado!")
	var game = get_node("/root/Mundo")
	game.tremer_camera()
	if GameState.quest_homero_error_happened == false:
		GameState.quest_homero_error_happened = true
		GameState.game_paused = true
		Dialogic.start("quest_homero_error")
		await Dialogic.timeline_ended
		GameState.game_paused = false
	spawn_inimigos_erro()
	

func efeito_acerto():
	$GPUParticles2D.restart()
	var sprite := $Sprite2D
	var tween = create_tween()
	tween.tween_property(
		sprite,
		"modulate",
		Color(1.2, 1.1, 0.6),
		0.12
	)
	tween.tween_interval(1.0)
	tween.tween_property(
		sprite,
		"modulate",
		Color(1, 1, 1),
		0.25
	)

func spawn_inimigos_erro():
	var player = get_tree().get_first_node_in_group("Player")
	if player == null:
		return
	
	for i in range(5):
		var inimigo = preload("res://Scenes/enemy.tscn").instantiate()
		var offset = Vector2(
			randf_range(-80, 80),
			randf_range(-80, 80)
		)
		inimigo.global_position = player.global_position + offset
		get_parent().add_child(inimigo)
