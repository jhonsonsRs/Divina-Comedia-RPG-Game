extends Control
class_name PuzzleFinalMenu

@onready var texto_label : RichTextLabel = $RichTextLabel
@onready var btn_natureza : Button = $BtnNatureza
@onready var btn_razao : Button = $BtnRazao
@onready var btn_ato : Button = $BtnAto
@onready var btn_habito : Button = $BtnHabito

var tem_natureza : bool = false
var tem_razao : bool = false
var tem_ato : bool = false
var tem_habito : bool = false

func _ready() -> void:
	self.visible = false
	atualizar_texto()

func toggle() -> void:
	self.visible = !self.visible
	GameState.game_paused = self.visible
	atualizar_texto()

func atualizar_texto() -> void:
	# Se tiver a pedra, mostra a palavra em destaque (ex: amarelo). Se não, mostra a lacuna.
	var p1 = "[color=yellow]NATUREZA[/color]" if tem_natureza else "[color=gray][ PEDRA 1 ][/color]"
	var p2 = "[color=yellow]RAZÃO[/color]" if tem_razao else "[color=gray][ PEDRA 2 ][/color]"
	var p3 = "[color=yellow]ATO[/color]" if tem_ato else "[color=gray][ PEDRA 3 ][/color]"
	var p4 = "[color=yellow]HÁBITO[/color]" if tem_habito else "[color=gray][ PEDRA 4 ][/color]"
	
	texto_label.text = "[center]A " + p1 + " não nos dá a virtude, ela apenas dá o potencial. É através da " + p2 + " e do " + p3 + " que aperfeiçoamos a alma. Pois a virtude não é um ato isolado, mas um " + p4 + ".[/center]"

	if tem_natureza and tem_razao and tem_ato and tem_habito:
		print("VITÓRIA! O puzzle final foi resolvido!")
		# Aqui pode chamar a cutscene final, abrir a porta, etc.

func _on_btn_natureza_pressed() -> void:
	# Troque "pedra_natureza" pelo nome exato que está no seu inventário!
	var pedras = GameState.get_items_by_type("pedra_natureza")
	if not pedras.is_empty():
		GameState.remove_item(pedras[0].id)
		tem_natureza = true
		btn_natureza.hide()
		atualizar_texto()
	else:
		print("Você ainda não tem essa pedra.")

func _on_btn_razao_pressed() -> void:
	var pedras = GameState.get_items_by_type("pedra_razao")
	if not pedras.is_empty():
		GameState.remove_item(pedras[0].id)
		tem_razao = true
		btn_razao.hide()
		atualizar_texto()

func _on_btn_ato_pressed() -> void:
	var pedras = GameState.get_items_by_type("pedra_ato")
	if not pedras.is_empty():
		GameState.remove_item(pedras[0].id)
		tem_ato = true
		btn_ato.hide()
		atualizar_texto()

func _on_btn_habito_pressed() -> void:
	var pedras = GameState.get_items_by_type("pedra_habito")
	if not pedras.is_empty():
		GameState.remove_item(pedras[0].id)
		tem_habito = true
		btn_habito.hide()
		atualizar_texto()
