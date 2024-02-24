extends Node2D

@export var par: int
@export var next_level_scene: PackedScene

var star: Node2D

func _ready():
	star = find_child("star")
	
	get_parent().find_child("CanvasLayer").find_child("par").text = "Par: {par}".format({"par": par})
	get_parent().find_child("player").set_shots(0)
	
	var player_pos = find_child("player_pos")
	var player = get_parent().find_child("player")
	player.global_position = player_pos.position
	player.global_position.y -= player.find_child("MeshInstance2D").mesh.size.y / 2.0
	
	var ball = get_parent().find_child("ball")
	ball.global_position = player_pos.position
	ball.global_position.y -= ball.find_child("MeshInstance2D").mesh.size.y / 2.0
	
	var hole = find_child("hole_pos")
	get_parent().find_child("hole").position = hole.position
	
	var camera = get_parent().find_child("camera")
	camera.global_position = find_child("flyby").get_child(0).global_position
	camera.flyby_points = find_child("flyby").get_children()
	camera.doing_flyby = true
	
func collect_star():
	star.visible = false
