extends Control
class_name MenuEscolhaVerso

@onready var verso_list = $Panel/VBoxContainer/VersoList
@onready var heroi_nome_label = $Panel/VBoxContainer/HeroiNome
@onready var pergunta_label = $Panel/VBoxContainer/Pergunta

var estatua_ref = null

func _ready() -> void:
	self.visible = false
	pergunta_label.text = "Qual verso pertence a esse herói?"

func toggle(versos : Array, estatua):
	estatua_ref = estatua
	self.visible = !self.visible
	if self.visible == true:
		GameState.game_paused = true
		heroi_nome_label.text = estatua.heroi_id
		print("Heroi ID:", estatua.heroi_id)
		print("Tipo:", typeof(estatua.heroi_id))
		for c in verso_list.get_children():
			c.queue_free()
		
		for item in versos:
			var btn = Button.new()
			btn.text = item.nome
			btn.modulate = item.cor
			btn.pressed.connect(_on_verso_escolhido.bind(item))
			verso_list.add_child(btn)
	else:
		GameState.game_paused = false

func abrir(versos : Array, estatua):
	estatua_ref = estatua
	GameState.game_paused = true
	visible = true
	heroi_nome_label.text = estatua.heroi_id
	
	for c in verso_list.get_children():
		c.queue_free()
	
	for item in versos:
		var btn = Button.new()
		btn.text = item.nome
		btn.modulate = item.cor
		btn.pressed.connect(_on_verso_escolhido.bind(item))
		verso_list.add_child(btn)

func fechar():
	self.visible = false
	GameState.game_paused = false

func _on_verso_escolhido(item : ItemData):
	estatua_ref.usar_verso(item)
	visible = false
