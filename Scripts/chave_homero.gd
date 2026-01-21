extends Area2D

@export var item_data : ItemData
@onready var sprite := $Sprite2D
var base_y : float
var item_id : String = "key_homero"

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	base_y = sprite.position.y
	_animar_brilho()
	
func _on_body_entered(body):
	if body.is_in_group("Player"):
		GameState.add_item(item_data)
		var root = Engine.get_main_loop().root
		if root.has_node("Mundo"):
			var game = root.get_node("Mundo")
			game.on_item_collected(item_id)
		queue_free()

func _process(delta):
	var time := Time.get_ticks_msec() / 1000.0
	sprite.position.y = base_y + sin(time * 2.0) * 6.0

func _animar_brilho():
	var tween := create_tween()
	tween.set_loops() 
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)

	tween.tween_property(
		sprite,
		"modulate",
		Color(1.4, 1.4, 1.4),
		0.6
	)
	tween.tween_property(
		sprite,
		"modulate",
		Color(1, 1, 1),
		0.6
	)
