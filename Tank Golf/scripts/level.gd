extends Node2D

@export var next_level_scene: PackedScene

func _ready():
	var tank = find_child("tank")
	get_parent().find_child("tank").position = tank.position
	
	var hole = find_child("hole")
	get_parent().find_child("hole").position = hole.position

func go_next_level():
	var next_level = next_level_scene.instantiate()
	get_parent().add_child(next_level, true)
	queue_free()
