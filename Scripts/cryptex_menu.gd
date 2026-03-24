extends Control
class_name CryptexMenu

var senha_correta : String = "VIRTUDE"
var alfabeto : String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
var letras_atuais = [0, 0, 0, 0, 0, 0, 0]

@onready var slots = [
	$HBoxContainer/Slot0/Letra,
	$HBoxContainer/Slot1/Letra,
	$HBoxContainer/Slot2/Letra,
	$HBoxContainer/Slot3/Letra,
	$HBoxContainer/Slot4/Letra,
	$HBoxContainer/Slot5/Letra,
	$HBoxContainer/Slot6/Letra
]

func _ready() -> void:
	self.visible = false

	for i in range(7):
		var slot_node = get_node("HBoxContainer/Slot" + str(i))
		# O bind(i, 1) avisa a função qual slot foi clicado e que é para SUBIR (+1)
		slot_node.get_node("BtnUp").pressed.connect(mudar_letra.bind(i, 1))
		# O bind(i, -1) avisa qual slot foi clicado e que é para DESCER (-1)
		slot_node.get_node("BtnDown").pressed.connect(mudar_letra.bind(i, -1))
	atualizar_textos()

func toggle() -> void:
	self.visible = !self.visible
	GameState.game_paused = self.visible

func mudar_letra(index_do_slot: int, direcao: int) -> void:
	letras_atuais[index_do_slot] += direcao
	if letras_atuais[index_do_slot] > 25:
		letras_atuais[index_do_slot] = 0
	elif letras_atuais[index_do_slot] < 0:
		letras_atuais[index_do_slot] = 25
	atualizar_textos()

func atualizar_textos() -> void:
	for i in range(7):
		slots[i].text = alfabeto[letras_atuais[i]]
		
func _on_btn_confirmar_pressed() -> void:
	var tentativa = ""
	for i in range(7):
		tentativa += alfabeto[letras_atuais[i]]
		
	if tentativa == senha_correta:
		print("CLACK! O Cryptex de Aristóteles foi aberto!")
		GameState.cryptex_liberado.emit()
		GameState.mark_quest_complete("quest_aristoteles")
		QuestManager.on_quest_finished()
		# destranca a porta final e fecha o menu
		toggle() 
	else:
		print("Senha incorreta... As engrenagens travam.")
		# colocar um som de erro ou tremer a tela aqui
