extends Control
class_name MenuEscolhaVerso

@onready var verso_list = $Panel/VersoList

var estatua_ref = null

func _ready() -> void:
	visible = false

func abrir(versos : Array, estatua):
	estatua_ref = estatua
	visible = true
	
	for c in verso_list.get_children():
		c.queue_free()
	
	for item in versos:
		var btn = Button.new()
		btn.text = item.nome
		btn.modulate = item.cor
		btn.pressed.connect(_on_verso_escolhido.bind(item))
		verso_list.add_child(btn)

func _on_verso_escolhido(item : ItemData):
	estatua_ref.usar_verso(item)
	visible = false
