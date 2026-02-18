extends Control
class_name GearMachineMenu

@onready var texture_rect : TextureRect = $TextureRect
@onready var button : Button = $Button

@export var menu_texture2 : Texture =  preload("res://Assets/gearMachineMenu2.png")
@export var menu_texture3 : Texture =  preload("res://Assets/gearMachineMenu3.png")
@export var menu_texture4 : Texture =  preload("res://Assets/gearMachineMenu4.png")


func _ready():
	self.visible = false
	
func toggle():
	self.visible = !self.visible
	if self.visible == true:
		GameState.game_paused = true
	else:
		GameState.game_paused = false

func _process(_delta: float) -> void:
	if GameState.engrenagens_coletadas == 1:
		texture_rect.texture = menu_texture2
	elif GameState.engrenagens_coletadas == 2:
		texture_rect.texture = menu_texture3
	elif GameState.engrenagens_coletadas == 3:
		texture_rect.texture = menu_texture4

func _on_button_pressed() -> void:
	var engrenagens = GameState.get_items_by_type("engrenagem")
	if engrenagens.is_empty():
		print("Você não tem engrenagens")
		return
	GameState.remove_item(engrenagens[0].id)
	GameState.engrenagens_coletadas += 1
	if GameState.engrenagens_coletadas >= GameState.engranagens_necessarias:
		self.visible = false
		GameState.game_paused = false
	
		
