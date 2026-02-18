extends StaticBody2D
class_name GearMachine

var gears_needed : int = 3
var gears_inserted : int = 0
var player_perto : bool = false
var can_interact : bool = true
@onready var interaction_icon : Sprite2D = $Sprite2D3
@export var menu_texture2 : Texture =  preload("res://Assets/gearMachine2.png")
@export var menu_texture3 : Texture =  preload("res://Assets/gearMachine3.png")
@export var menu_texture4 : Texture =  preload("res://Assets/gearMachine4.png")

@onready var sprite : Sprite2D = $Sprite2D

func _ready() -> void:
	$Area2D.body_entered.connect(_on_body_entered)
	$Area2D.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.is_in_group("Player"):
		player_perto = true
		if can_interact == true:
			interaction_icon.visible = true
		
func _on_body_exited(body):
	if body.is_in_group("Player"):
		player_perto = false
		interaction_icon.visible = false

func interagir():
	var game = get_node("/root/Mundo")
	game.menu_gear_machine.toggle()

func _process(_delta):
	if player_perto and can_interact and Input.is_action_just_pressed("interact"):
		interagir()

	if Input.is_action_just_pressed("leave"):
		var game = get_node("/root/Mundo")
		game.menu_verso.fechar()
	atualizar_estado()
	
func atualizar_estado():
	if GameState.engrenagens_coletadas == 1:
		sprite.texture = menu_texture2
	elif GameState.engrenagens_coletadas == 2:
		sprite.texture = menu_texture3
	elif GameState.engrenagens_coletadas >= 3:
		can_interact = false
		sprite.texture = menu_texture4
		interaction_icon.visible = false
