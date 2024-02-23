extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var stationary_timer: int = 0
var stationary_timer_limit: int = 100

var game: Node2D
var player: Node2D
var camera: Camera2D
var trail: Line2D

func _ready():
	game = get_parent()
	player = game.find_child("player")
	camera = game.find_child("camera")
	trail = game.find_child("trail")

func _physics_process(delta):
	if player.can_act or camera.doing_flyby:
		return
		
	velocity.y += gravity * delta
		
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		velocity = velocity.bounce(collision_info.get_normal()) * Vector2(0.99, 0.7)
		
	trail.update_trail(global_position)
	
	if velocity.x < 10 and velocity.x > -10 and velocity.y < 50 and velocity.y > -50:
		stationary_timer += 1
		if stationary_timer > stationary_timer_limit:
			if collision_info and collision_info.get_collider().name == "hole_bottom":
				game.go_next_level()
			else:
				player.global_position = global_position
				player.global_position.y -= (player.find_child("MeshInstance2D").mesh.size.y - find_child("MeshInstance2D").mesh.size.y) / 2.0
				player.can_act = true
				player.trajectory.show()
			trail.clear_points()
	else:
		stationary_timer = 0
		rotation += velocity.x / 2000.0
