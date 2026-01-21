extends Control
class_name InventarioUI

@onready var grid = $Panel/HBoxContainer/ItemGrid
@onready var icon = $Panel/HBoxContainer/Detalhes/Icone
@onready var nome = $Panel/HBoxContainer/Detalhes/Nome
@onready var descricao = $Panel/HBoxContainer/Detalhes/Descricao
@onready var btn_usar = $Panel/HBoxContainer/Detalhes/Usar
var slot_scene = preload("res://Scenes/inventory_slot.tscn")
var item_selecionado : ItemData = null
var max_slots : int = 16

func _ready() -> void:
	self.visible = false
	self.btn_usar.pressed.connect(_on_usar_item)
	
func abrir():
	self.visible = true
	atualizar()

func fechar():
	self.visible = false

func toggle():
	self.visible = !self.visible
	if self.visible:
		GameState.game_paused = true
		atualizar()
	else:
		GameState.game_paused = false

func atualizar():
	for c in grid.get_children():
		c.queue_free()

	for item in GameState.inventory:
		var btn = TextureButton.new()
		btn.texture_normal = item.icon
		btn.pressed.connect(_on_item_clicado.bind(item))
		grid.add_child(btn)

	_limpar_detalhes()

	
func _on_item_clicado(item : ItemData):
	item_selecionado = item
	icon.texture = item.icon
	nome.text = item.nome
	descricao.text = item.descricao
	btn_usar.visible = item.utilizavel
		
func _limpar_detalhes():
	icon.texture = null
	nome.text = ""
	descricao.text = ""
	btn_usar.visible = false
	
func _on_usar_item():
	if item_selecionado == null:
		return
	print("Usou:", item_selecionado.nome)
	
	
	
	
	
