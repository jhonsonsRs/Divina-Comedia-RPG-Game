extends CanvasLayer

@onready var botao_entendi = $Panel/Button

func _ready():
	GameState.game_paused = true
	process_mode = Node.PROCESS_MODE_ALWAYS
	botao_entendi.pressed.connect(_on_fechar_pressed)
	
func _process(_delta):
	if Input.is_action_just_pressed("ui"):
		_on_fechar_pressed()

func _on_fechar_pressed():
	GameState.game_paused = false
	queue_free()
