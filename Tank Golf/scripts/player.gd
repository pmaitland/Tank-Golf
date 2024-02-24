extends Node2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var ball_source: Node2D
var trajectory: Line2D
var club: Node2D

var ball: CharacterBody2D

var can_act: bool = false

func _ready():
	ball_source = find_child("ball_source")
	trajectory = find_child("trajectory")
	club = find_child("club")
	
	ball = get_parent().find_child("ball")

func _physics_process(delta):
	var mouse_position = get_global_mouse_position()
	if mouse_position.x - club.global_position.x > 0:
		club.rotation = 3*PI/2.0
		club.rotation -= clamp(mouse_position.y / 1000.0, -PI/2.0, PI/2.0)
	else:
		club.rotation = PI/2.0
		club.rotation += clamp(mouse_position.y / 1000.0, -PI/2.0, PI/2.0)
			
	if can_act:
		ball_source.look_at(mouse_position)
		var ball_velocity = (mouse_position - ball_source.global_position).normalized() * clampf((mouse_position - ball_source.global_position).length() * 2, -2000, 2000)
		trajectory.update_trajectory(ball_source.global_position, ball_velocity, gravity, delta)
		
		if Input.is_action_just_pressed("ui_accept"):
			ball.global_position = ball_source.global_position
			ball.velocity = ball_velocity
			trajectory.hide()
			can_act = false
