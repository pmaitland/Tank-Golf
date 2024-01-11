extends Camera2D

var tank: CharacterBody2D
var ball: RigidBody2D

var target: Node2D

func _ready():
	tank = get_parent().find_child("tank")
	ball = get_parent().find_child("ball")
	target = tank
	
func _physics_process(_delta):
	if tank.can_act:
		target = tank
	elif ball.position.x > -5000:
		target = ball
	global_position = target.global_position
