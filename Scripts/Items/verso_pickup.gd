extends Area2D

@export var item_data : ItemData

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	
func _on_body_entered(body):
	if body.is_in_group("Player"):
		GameState.add_item(item_data)
		queue_free()
