extends Camera2D

var player: Node2D
var ball: CharacterBody2D

var doing_flyby: bool = false
var flyby_points: Array[Node]
var current_flyby_point_index: int = 0

func _ready():
	player = get_parent().find_child("player")
	ball = get_parent().find_child("ball")
	
func _physics_process(_delta):
	if doing_flyby:
		zoom = Vector2.ONE * 2
		player.can_act = false
		global_position = global_position.move_toward(flyby_points[current_flyby_point_index].global_position, 10)
		if global_position.distance_to(flyby_points[current_flyby_point_index].global_position) < 10:
			current_flyby_point_index += 1
		if current_flyby_point_index >= flyby_points.size():
			doing_flyby = false
			current_flyby_point_index = 0
			player.can_act = true
			player.trajectory.show()
	else:
		if player.can_act:
			global_position = player.global_position
			var zoom_level = abs((get_viewport().size / 2.0) - get_viewport().get_mouse_position()) / 1000.0
			if zoom_level.x != 0:
				zoom_level.x = 1 / zoom_level.x
			if zoom_level.y != 0:
				zoom_level.y = 1 / zoom_level.y
			zoom_level.x = clamp(min(zoom_level.x, zoom_level.y), 1, 4)
			zoom_level.y = zoom_level.x
			zoom = zoom.lerp(zoom_level, 0.1)
		else:
			global_position = ball.global_position
			zoom = Vector2.ONE * 2
