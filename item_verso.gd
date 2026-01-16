extends Node2D
class_name ItemVerso

@export var verso_id : String = "verso_aquiles"
@export var texto_ao_pegar : String = "Você encontrou um verso sobre a Ira de um Guerreiro..."

func _ready():
	if GameState.is_active(verso_id) == false:
		queue_free()
		
func on_area_entered(body):
	if body.is_in_group("Player"):
		coletar()

func coletar():
	print("Pegou: " + verso_id)
	GameState.mark_collected(verso_id)
	# UI.mostrar_aviso(texto_ao_pegar)
	queue_free()
