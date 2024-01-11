extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var gun: Node2D
var gun_end: Node2D

var ball: RigidBody2D

var can_act: bool = true

func _ready():
	gun = find_child("gun")
	gun_end = gun.find_child("end")
	
	ball = get_parent().find_child("ball")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	var direction = Input.get_axis("ui_left", "ui_right")
	if can_act and direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	gun.look_at(get_global_mouse_position())
	
	if can_act and Input.is_action_just_pressed("ui_accept"):
		ball.move(gun_end.global_position, (get_global_mouse_position() - gun_end.global_position) / 10)
		ball.been_fired = true
		can_act = false
