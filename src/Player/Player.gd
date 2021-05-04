extends KinematicBody2D

onready var Raycast = $PlayerRaycast

enum Movement {
	WALKING
	SPRINTING
}

#Consts
const ACCELERATION = 40
const SPRINT_ACCELERATION = 80
const JUMP_HEIGHT = 800
const GRAVITY = -40
const GRAPPLE_Y = 600
const GRAPPLE_X = 400

#Variables
var velocity = Vector2()
var direction = 0
var isOnGround = 0

var isOnWall = 0
var grappleDirection = 0

var jumps = 0
var default_jumps = 1

var grappleJumps = 0
var default_grappleJumps = 2

var DEBUGvar = 0

var move_style 
var jumpable_wall : bool

func _process(_delta):
	if grappleJumps == 1:
		modulate = Color(0, 0.6, 0)
	elif grappleJumps == 0:
		modulate = Color(0, 0.3, 0)
	else:
		modulate = Color (1, 1, 1)
# warning-ignore:return_value_discarded
	move_and_slide(velocity, Vector2(0, -1))
	pass


func _physics_process(_delta):
	# Check if player is sprinting or not.
	if Input.is_action_pressed("sprint"):
		move_style = Movement.SPRINTING
	else:
		move_style = Movement.WALKING
	
	# Checks if player is coliding with floor
	if is_on_floor():
		isOnGround = true
	else:
		isOnGround = false
	
	if is_on_wall() && velocity.y > 10:
		isOnWall = true
	else:
		isOnWall = false
	
	tile_detector()
	horizontal_movement()
	vertical_movement()
	pass


func horizontal_movement():
	
	direction = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	
	if move_style == Movement.SPRINTING:
		velocity.x += SPRINT_ACCELERATION * direction
		velocity.x *= 0.9
		yield(get_tree().create_timer(0.1), "timeout")
	else:
		velocity.x += ACCELERATION * direction
		velocity.x *= 0.85
	
	if abs(velocity.x) < 20:
		velocity.x = 0
	pass


func vertical_movement():
	if isOnGround:
		velocity.y = 10
		jumps = default_jumps
		grappleJumps = default_grappleJumps
		grappleDirection = 0
	elif !isOnGround:
		if jumps == default_jumps:
			jumps -= 1
		velocity.y += -GRAVITY
	
	if isOnWall && jumpable_wall:
		if grappleDirection < 0 && velocity.x > 0:
			grappleJumps = default_grappleJumps
		elif grappleDirection > 0 && velocity.x < 0:
			grappleJumps = default_grappleJumps
		grappleDirection = velocity.x
		velocity.y = 100
	
#   Jumping
	if Input.is_action_just_pressed("jump"):
		#Jump from the wall
		if isOnWall && grappleJumps > 0 && jumpable_wall == true:
			#Jumps on the opposite side of grappling
			if velocity.x > 0:
				velocity.x = -GRAPPLE_X
			else:
				grappleDirection = -1
				velocity.x = GRAPPLE_X
				
			velocity.y = -GRAPPLE_Y
			grappleJumps -= 1
		
		# Normal jump from ground
		elif jumps > 0:
			velocity.y = -JUMP_HEIGHT
			jumps -= 1


func tile_detector():
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		
		if collision.collider is TileMap:
			var tile_pos = collision.collider.world_to_map(position)
			tile_pos -= collision.normal
			var tile_id = collision.collider.get_cellv(tile_pos)
			if tile_id == 2:
				queue_free()
				SceneTransition.player_died()
			if tile_id == 0:
				jumpable_wall = true
			else:
				jumpable_wall = false

