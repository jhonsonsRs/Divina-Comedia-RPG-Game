extends CharacterBody2D

@export var speed : float = 80.0
@export var dash_speed : float = 400.0
var dash_direction : Vector2 = Vector2.ZERO

@onready var state_timer : Timer = $StateTimer
@onready var sprite : Sprite2D = $Sprite2D
@onready var game_manager = get_node_or_null("/root/Mundo")
@onready var player : CharacterBody2D = game_manager.player
