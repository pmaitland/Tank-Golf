extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var stationary_timer: int = 0
var stationary_timer_limit: int = 100

var game: Node2D
var player: Node2D
var camera: Camera2D
var trail: Line2D
var area: Area2D

var in_water = false

func _ready():
	game = get_parent()
	player = game.find_child("player")
	camera = game.find_child("camera")
	trail = game.find_child("trail")
	area  = find_child("Area2D")

func _physics_process(delta):
	if player.can_act or camera.doing_flyby:
		return
		
	var resistance = 0.995
		
	for a in area.get_overlapping_areas():
		if a.name == "water area":
			resistance = 0.895
			in_water = true
		
	velocity.y += gravity * delta
	velocity *= resistance
		
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		var bounce_dampening = 0.85
		var boosting = false
		if collision_info.get_collider().name == "sand":
			bounce_dampening = 0.25
		elif collision_info.get_collider().name == "mushroom":
			bounce_dampening = 1.5
			boosting = true
		var bounce_velocity = velocity.bounce(collision_info.get_normal())
		if boosting or bounce_velocity.length() * bounce_dampening < bounce_velocity.length() - 10:
			velocity = bounce_velocity * bounce_dampening
		else:
			if velocity.x > 0:
				velocity = Vector2(min(0, bounce_velocity.x + 10), max(0, bounce_velocity.y - 10))
			else:
				velocity = Vector2(max(0, bounce_velocity.x - 10), max(0, bounce_velocity.y - 10))
				
	velocity = velocity.clamp(Vector2.ONE*-1500, Vector2.ONE*1500)
		
	trail.update_trail(global_position)
	
	if velocity.x < 10 and velocity.x > -10 and velocity.y < 50 and velocity.y > -50:
		stationary_timer += 1
		if stationary_timer > stationary_timer_limit:
			if collision_info and collision_info.get_collider().name == "hole_bottom":
				game.go_next_level()
			else:
				if not in_water:
					player.global_position = global_position
					player.global_position.y -= (player.find_child("MeshInstance2D").mesh.size.y - find_child("MeshInstance2D").mesh.size.y) / 2.0
				in_water = false
				player.can_act = true
				player.trajectory.show()
			trail.clear_points()
	else:
		stationary_timer = 0
		rotation += velocity.x / 2000.0
