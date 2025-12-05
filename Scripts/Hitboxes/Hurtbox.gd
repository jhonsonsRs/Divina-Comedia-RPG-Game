extends Area2D
class_name Hurtbox

signal hit_received(hitbox: Area2D)

func _ready() -> void:
	connect("area_entered", on_area_entered)

func on_area_entered(area):
	if area is Hitbox:
		emit_signal("hit_received", area)
