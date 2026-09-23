extends CharacterBody2D
class_name Player_Object

@onready var sprite := $Sprite2D
@onready var wall_collider := $Climb_wall_collider

@export var speed := 600.0
@export var jump_strength := 1500.0
@export var gravity := 4500.0

var can_climb_activate := false # Is player next to wall that can be climbed
var wall_that_is_climbed_on : Climb_Wall
var is_climbing := false
var is_jumping := false
const coyote_init_jump_time := 0.1 
var coyote_jump_time := 0.1


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	if (is_climbing == true):
		ClimbState(delta)
	else:
		NormalState(delta)
	pass

func ClimbState(delta: float):
	var _horizontal_direction = (
		Input.get_action_strength("moveRight")
		- Input.get_action_strength("moveLeft")
	)
	var _vertical_direction = (
		Input.get_action_strength("moveDown")
		- Input.get_action_strength("moveUp")
	)
	var moveDir = Vector2(_horizontal_direction, _vertical_direction)
	if (Input.is_action_just_pressed("jump")):
		is_jumping = true
		velocity.y = -jump_strength
		is_climbing = false
	if (IsClimbColliderInsideArea(moveDir)):
		transform.origin += moveDir
	pass

func IsClimbColliderInsideArea(moveDir : Vector2):
	var wall = wall_that_is_climbed_on
	print("collision shape = ",  wall.CollisionShape.shape.size)
	if (transform.origin.x - wall_collider.shape.size.x + moveDir.x < wall.transform.origin.x - 32 * wall.scale.x or
		transform.origin.x + wall_collider.shape.size.x + moveDir.x > wall.transform.origin.x + 32 * wall.scale.x or 
		transform.origin.y - wall_collider.shape.size.y + moveDir.y < wall.transform.origin.y - 32 * wall.scale.y or 
		transform.origin.y + wall_collider.shape.size.y + moveDir.y > wall.transform.origin.y + 32 * wall.scale.y):
		return false
	return true

func NormalState(delta: float):
	var _horizontal_direction = (
		Input.get_action_strength("moveRight")
		- Input.get_action_strength("moveLeft")
	)
	if (is_on_floor() == false):
		coyote_jump_time -= delta
	else:
		coyote_jump_time = coyote_init_jump_time
		is_jumping = false
	
	if (Input.is_action_just_pressed("jump") and can_climb_activate):
		is_climbing = true
		pass
	if (coyote_jump_time > 0 and is_jumping == false and Input.is_action_pressed("jump")):
		is_jumping = true
		velocity.y = -jump_strength
	velocity.x = _horizontal_direction * speed
	velocity.y += gravity * delta
	
	if (abs(_horizontal_direction) > 0.01): # flip sprite left/right
		sprite.flip_h = _horizontal_direction < 0
	
	move_and_slide()
	pass

func EnterClimbWall(climbWall: Climb_Wall):
	wall_that_is_climbed_on = climbWall
	can_climb_activate = true
	pass

func ExitClimbWall():
	wall_that_is_climbed_on = null
	is_climbing = false
	can_climb_activate = false
	pass
