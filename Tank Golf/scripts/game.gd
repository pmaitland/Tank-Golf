extends Node2D

var player: Node2D
var level: Node2D

var level_ui: Control
var level_end_ui: Control

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	player = find_child("player")
	level = get_child(0)
	level_ui = find_child("CanvasLayer").find_child("level ui")
	level_end_ui = find_child("CanvasLayer").find_child("level end ui")
	
func _process(_delta):
	if level_end_ui.visible and Input.is_action_just_pressed("ui_accept"):
		go_next_level()
	
func finish_level():
	level_end_ui.find_child("star 1").visible = false
	level_end_ui.find_child("star 2").visible = false
	level_end_ui.find_child("star 3").visible = false
	level_end_ui.find_child("par").text = "Par: {par}".format({"par": level.par})
	level_end_ui.find_child("shots").text = "Shots: {shots}".format({"shots": player.shots})
	level_ui.visible = false
	level_end_ui.visible = true
	if player.shots <= level.par:
		level_end_ui.find_child("star 1").visible = true
	if not level.star.visible:
		level_end_ui.find_child("star 2").visible = true
		
func go_next_level():
	level_ui.visible = true
	level_end_ui.visible = false
	var next_level = level.next_level_scene.instantiate()
	level.queue_free()
	add_child(next_level, true)
	move_child(next_level, 0)
	level = next_level
