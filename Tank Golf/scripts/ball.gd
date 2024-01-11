extends RigidBody2D

var new_position: Vector2
var new_impulse: Vector2
var set_new_position: bool = true
var new_tank_position: Vector2 = Vector2(-5000, -5000)

var been_fired: bool = false

var in_hole: bool = false

var tank: CharacterBody2D

func _ready():
	tank = get_parent().find_child("tank")

func _physics_process(_delta):	
	if !is_moving():
		for body in get_colliding_bodies():
			if body.name == "bottom":
				get_parent().find_child("level").go_next_level()
			
		if been_fired:
			new_tank_position = global_position
			new_tank_position.y -= tank.find_child("CollisionShape2D").shape.height * tank.scale.y / 4
			been_fired = false
		move(Vector2(-5000, -5000))

func _integrate_forces(state):
	if !set_new_position:
		state.transform = Transform2D(0.0, new_position)
		state.linear_velocity = Vector2(0, 0)
		apply_central_impulse(new_impulse)
		if new_tank_position != Vector2(-5000, -5000):
			tank.global_position = new_tank_position
			new_tank_position = Vector2(-5000, -5000)
			tank.can_act = true
		set_new_position = true
	
func move(pos: Vector2, impulse: Vector2 = Vector2(0, 0)):
	new_position = pos
	new_impulse = impulse
	set_new_position = false
	
func is_moving():
	return !(abs(linear_velocity.x) < 2 and abs(linear_velocity.y) < 0.005)
