extends Node2D
@export var peso : float = 5.0
@export var follow_speed : float = 8.0
@export var imagem_do_item : Texture2D

var holder = null
var player_perto = null

func _ready() -> void:
	if imagem_do_item != null:
		$Sprite2D.texture = imagem_do_item

func _physics_process(delta: float) -> void:
	if holder:
		var target_position = holder.global_position + Vector2(0, -20)
		global_position = global_position.lerp(target_position, follow_speed * delta)
		if Input.is_action_just_pressed("interact"):
			holder = null
	else:
		if player_perto and Input.is_action_just_pressed("interact"):
			holder = player_perto

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_perto = body

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player_perto = null
