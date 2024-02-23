extends Line2D

func update_trail(pos: Vector2):
	add_point(pos)
	if get_point_count() > 25:
		remove_point(0)
