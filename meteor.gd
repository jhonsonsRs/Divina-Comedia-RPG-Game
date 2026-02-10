extends Area2D

@export var damage : int = 10
@export var warning_time : float = 3.0
@export var blast_radius : float = 60.0

var time_passed: float = 0.0
var exploded : bool = false

func _ready():
	modulate.a = 0.5
	set_process(true)

func _process(delta):
	if exploded: return
	time_passed += delta
	queue_redraw()
	if time_passed >= warning_time:
		explode()
		
func explode():
	exploded = true
	print("BOOM! Meteoro caiu.")
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("Player"):
			if body.has_method("take_damage"):
				body.take_damage(damage)
			elif body.has_method("hit"):
				body.hit(damage)
	queue_free()

func _draw():
	if not exploded:
		draw_arc(Vector2.ZERO, blast_radius, 0, TAU, 32, Color.RED, 2.0)
		var progress = time_passed / warning_time
		var fill_color = Color(1, 0.5, 0, 0.5 * progress) 
		draw_circle(Vector2.ZERO, blast_radius * progress, fill_color)
