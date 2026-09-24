extends CharacterBody2D
class_name Player_Object

@onready var sprite := $Sprite2D
@onready var wall_collider := $Climb_wall_collider
@onready var tile_map := $"../TileMapLayer"

var speed := 600.0
var jump_strength := 100
var gravity := 3000.0 

var can_climb_activate := false # Is player next to wall that can be climbed
var wall_that_is_climbed_on : Climb_Wall
var is_climbing := false
var is_jumping := false
var is_falling := false
const coyote_init_jump_time := 0.1 
var coyote_jump_time := 0.1
var prev_friction := 999999.0

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
	if (IsClimbColliderInsideArea(Vector2(moveDir.x,0))):
		transform.origin.x += moveDir.x
	if (IsClimbColliderInsideArea(Vector2(0,moveDir.y))):
		transform.origin.y += moveDir.y
	pass

func IsClimbColliderInsideArea(moveDir : Vector2):
	# checking if you move is valid inside of climbable wall
	var wall = wall_that_is_climbed_on
	if (transform.origin.x - wall_collider.shape.size.x + moveDir.x < wall.transform.origin.x - 32 * wall.scale.x or
		transform.origin.x + wall_collider.shape.size.x + moveDir.x > wall.transform.origin.x + 32 * wall.scale.x or 
		transform.origin.y - wall_collider.shape.size.y + moveDir.y < wall.transform.origin.y - 32 * wall.scale.y or 
		transform.origin.y + wall_collider.shape.size.y + moveDir.y > wall.transform.origin.y + 32 * wall.scale.y):
		return false
	return true

func NormalState(delta: float):
	# Get on what type of ground player is if it's ice its more slipery
	var friction = GetGroundFriction() 
	is_falling = velocity.y > 0
	
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
		OnClimbWallEnter()
		pass
		
	if (coyote_jump_time > 0 and is_jumping == false and Input.is_action_pressed("jump")):
		# If your friction is low make it higher for easier jumps
		if (friction < 0.5):
			prev_friction = 0.5
			friction = 0.5
		is_jumping = true
		velocity.y = -jump_strength
		print(velocity.y)
		print(jump_strength)
	if (is_jumping and Input.is_action_just_released("jump") and is_falling == false):
		velocity.y /= 50
		pass
		

	# ease between speed to apply friction
	velocity.x = move_toward(velocity.x, _horizontal_direction * speed, friction * 1000 * delta)
	velocity.y += gravity * delta
	
	if (abs(_horizontal_direction) > 0.01): # flip sprite left/right
		sprite.flip_h = _horizontal_direction < 0
	
	move_and_slide()
	pass
	
## Gets friction below you based on custom data in Tilemap
func GetGroundFriction():
	if (tile_map == null):
		return prev_friction
	var tile_pos = tile_map.local_to_map(tile_map.to_local(transform.origin + Vector2.DOWN * 33))
	var tile_type = tile_map.get_cell_tile_data(tile_pos)
	if (tile_type != null):
		var tile_friction = tile_type.get_custom_data("friction")
		if (tile_friction != null):
			prev_friction = tile_friction
			return tile_friction
	return prev_friction

func OnClimbWallEnter():
	velocity = Vector2.ZERO
	prev_friction = 999999
	is_climbing = true
	# place to nearest possible wallclimb
	if (IsClimbColliderInsideArea(Vector2.ZERO) == false):
		if (transform.origin.x - wall_collider.shape.size.x < wall_that_is_climbed_on.transform.origin.x - 32 * wall_that_is_climbed_on.scale.x):
			transform.origin.x = wall_that_is_climbed_on.transform.origin.x - 32 * wall_that_is_climbed_on.scale.x + wall_collider.shape.size.x
		elif (transform.origin.x + wall_collider.shape.size.x > wall_that_is_climbed_on.transform.origin.x + 32 * wall_that_is_climbed_on.scale.x):
			transform.origin.x = wall_that_is_climbed_on.transform.origin.x + 32 * wall_that_is_climbed_on.scale.x - wall_collider.shape.size.x
		if (transform.origin.y - wall_collider.shape.size.y < wall_that_is_climbed_on.transform.origin.y - 32 * wall_that_is_climbed_on.scale.y):
			transform.origin.y = wall_that_is_climbed_on.transform.origin.y - 32 * wall_that_is_climbed_on.scale.y + wall_collider.shape.size.y
		elif (transform.origin.y + wall_collider.shape.size.y > wall_that_is_climbed_on.transform.origin.y + 32 * wall_that_is_climbed_on.scale.y):
			transform.origin.y = wall_that_is_climbed_on.transform.origin.y + 32 * wall_that_is_climbed_on.scale.y - wall_collider.shape.size.y
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
