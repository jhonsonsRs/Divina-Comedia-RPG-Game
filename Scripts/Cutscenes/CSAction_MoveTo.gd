extends CSAction
class_name CSAction_MoveTo

var character : Node2D
var target_position : Vector2
var marker_name : String = ""
var duration : float = 2.0 

func play(controller: Node) -> void:
	if not is_instance_valid(character): return
	
	var final_pos = target_position
	
	# 1. Lógica do Marker (Prioridade sobre target_position)
	if marker_name != "":
		var root = controller.get_tree().root
		var marker = root.find_child(marker_name, true, false)
		
		if marker:
			final_pos = marker.global_position
		else:
			printerr("Cutscene Error: Marker '", marker_name, "' não encontrado!")
	
	# 2. CONTROLE DE ANIMAÇÃO MANUAL
	# Como o GameState pausou a física do boneco, nós temos que animar "na mão".
	# Verificamos se o personagem tem a propriedade 'animation_tree'
	if "animation_tree" in character and character.animation_tree:
		# Calcula para onde ele vai olhar
		var direction = character.global_position.direction_to(final_pos)
		
		# Atualiza o BlendSpace (Esquerda/Direita/Cima/Baixo)
		character.animation_tree["parameters/idle/blend_position"] = direction
		character.animation_tree["parameters/run/blend_position"] = direction
		
		# Força a animação de CORRER
		character.animation_tree["parameters/playback"].travel("run")
	
	# 3. Movimento via Tween (Ignora a física parada)
	var tween = controller.create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	# Move suavemente da posição atual até a final
	tween.tween_property(character, "global_position", final_pos, duration)
	
	await tween.finished
	
	# 4. VOLTA PARA IDLE NO FINAL
	if "animation_tree" in character and character.animation_tree:
		character.animation_tree["parameters/playback"].travel("idle")
