extends Area2D

@export var boss_node : CharacterBody2D
@export var boss_hud : CanvasLayer

func _ready():
	if boss_hud:
		boss_hud.visible = false
	

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		start_boss_battle()
	
func start_boss_battle():
	print("A batalha começou!")
	boss_hud.visible = true
	boss_node.ativar_boss()
	queue_free()
