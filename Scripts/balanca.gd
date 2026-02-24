extends Node2D
@export var max_rotation : float = 15.0
@export var tolerance : float = 1.0
@export var total_pecas_puzzle : int = 7

var pecas_esquerda : int = 0
var pecas_direita : int = 0
var left_weight : float = 0.0
var right_weight : float = 0.0
var target_rotation : float = 0.0

func _process(delta: float) -> void:
	$Beam.rotation_degrees = lerp($Beam.rotation_degrees, target_rotation, 5 * delta)
	$Beam/LeftPlate.global_rotation_degrees = 0
	$Beam/RightPlate.global_rotation_degrees = 0
	
func update_balance():
	var difference = right_weight - left_weight
	var ratio = clamp(difference/20.0, -1.0, 1.0)
	target_rotation = ratio * max_rotation
	var total_pecas_na_balanca = pecas_esquerda + pecas_direita
	if abs(difference) <= tolerance and total_pecas_na_balanca == total_pecas_puzzle:
		print("VITÓRIA DEFINITIVA! Todas as peças usadas e a balança está equilibrada!")
		#liberar pedra

func _on_left_area_entered(area: Area2D) -> void:
	var item = area.get_parent()
	if "peso" in item:
		left_weight += item.peso
		pecas_esquerda += 1
		update_balance()

func _on_left_area_exited(area: Area2D) -> void:
	var item = area.get_parent()
	if "peso" in item:
		left_weight -= item.peso
		pecas_esquerda -= 1
		update_balance()
	
func _on_right_area_entered(area: Area2D) -> void:
	var item = area.get_parent()
	if "peso" in item:
		right_weight += item.peso
		pecas_direita += 1
		update_balance()
	
func _on_right_area_exited(area: Area2D) -> void:
	var item = area.get_parent()
	if "peso" in item:
		right_weight -= item.peso
		pecas_direita -= 1
		update_balance()
	
