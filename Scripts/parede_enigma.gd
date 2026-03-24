extends StaticBody2D

@onready var area2d : Area2D = $Area2D
var player_perto : bool = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_perto = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_perto = false

func _process(_delta: float) -> void:
	if player_perto and Input.is_action_just_pressed("interact"):
		print("1. Apertou E perto da pedra!") 
		
		var game = get_node_or_null("/root/Mundo")
		if game:
			if game.ui_node.has_node("PuzzleFinalMenu"): 
				print("3. Achou o Menu! Vai abrir agora.")
				game.ui_node.get_node("PuzzleFinalMenu").toggle()
			else:
				print("ERRO NO 3: Não achou o menu. Os nós que existem dentro de ui_node são: ", game.ui_node.get_children())
		else:
			print("ERRO NO 2: Não achou o /root/Mundo")
