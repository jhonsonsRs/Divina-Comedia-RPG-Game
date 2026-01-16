extends CSAction
class_name CSAction_MoveCamera

# -- Variáveis de Configuração --
var camera: Camera2D
var target: Node2D          # <--- AGORA SE CHAMA target
var tempo: float = 1.5
var novo_zoom: Vector2 = Vector2.ZERO
var esperar_terminar: bool = true

func play(controller: Node) -> void:
	if not is_instance_valid(camera) or not is_instance_valid(target):
		printerr("CSAction_MoveCamera: Erro - Camera ou Target não definidos!")
		return

	var tween = controller.create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property(camera, "global_position", target.global_position, tempo)
	
	if novo_zoom != Vector2.ZERO:
		tween.parallel().tween_property(camera, "zoom", novo_zoom, tempo)
	
	if esperar_terminar:
		await tween.finished
