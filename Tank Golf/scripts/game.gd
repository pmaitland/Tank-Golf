extends Node2D

var level: Node2D

func _ready():
	level = get_child(0)

func go_next_level():
	var next_level = level.next_level_scene.instantiate()
	level.queue_free()
	add_child(next_level, true)
	move_child(next_level, 0)
	level = next_level
