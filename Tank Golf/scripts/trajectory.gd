extends Line2D

func update_trajectory(start: Vector2, velocity: Vector2, gravity: float, delta: float):
	var max_points = 50
	clear_points()
	var pos = to_local(start)
	for i in max_points:
		add_point(pos)
		velocity.y += gravity * delta
		velocity *= 0.995
		pos += velocity * delta
