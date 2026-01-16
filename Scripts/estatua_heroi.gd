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

func usar_verso(item : ItemData):
	if item.id == verso_correto_id:
		aceitar_verso(item)
	else:
		erro_verso()
		
func aceitar_verso(item):
	GameState.remove_item(item.id)
	var game = get_node("/root/Mundo")
	game.on_quest_event("verso_" + heroi_id)
	
func erro_verso():
	print("Verso errado!")
