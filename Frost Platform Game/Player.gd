extends CharacterBody2D

@onready var sprite := $Sprite2D

@export var speed := 600.0
@export var jump_strength := 1500.0
@export var gravity := 4500.0

var is_jumping := false
var coyote_init_jump := 0.1
var coyote_jump_time := 0.1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var _horizontal_direction = (
		Input.get_action_strength("moveRight")
		- Input.get_action_strength("moveLeft")
	)
	if (is_on_floor() == false):
		coyote_jump_time -= delta
		print(coyote_jump_time)
	else:
		coyote_jump_time = coyote_init_jump
		is_jumping = false
	
	if (coyote_jump_time > 0 and is_jumping == false and Input.is_action_pressed("jump")):
		is_jumping = true
		velocity.y = -jump_strength
	velocity.x = _horizontal_direction * speed
	velocity.y += gravity * delta
	
	if (abs(_horizontal_direction) > 0.01):
		sprite.flip_h = _horizontal_direction < 0
	
	move_and_slide()
	
	pass
