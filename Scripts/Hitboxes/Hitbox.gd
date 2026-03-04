extends Area2D
class_name Hitbox

@export var damage : int

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	var alvo = area.owner
	if alvo == null:
		alvo = area.get_parent()
	if alvo.is_in_group("invulneravel"):
		if owner is Player:
			owner.recuo_da_espada(alvo.global_position)
