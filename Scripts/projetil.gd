extends Area2D

@onready var player = get_tree().get_first_node_in_group("Player")

var direction : Vector2 = Vector2.ZERO
var speed : float = 150.0

func _ready() -> void:
	direction = (player.global_position - global_position).normalized()

func _physics_process(delta):
	position += direction * speed * delta
	
func _on_body_entered(_body) -> void:
	if _body.is_in_group("Player"):
		queue_free()
