extends CharacterBody2D

@export var speed := 600.0
@export var jump_strength := 1500.0
@export var gravity := 4500.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var _horizontal_direction = (
		Input.get_action_strength("moveRight")
		- Input.get_action_strength("moveLeft")
	)
	if (is_on_floor() and Input.is_action_pressed("jump")):
		velocity.y -= jump_strength
	velocity.x = _horizontal_direction * speed
	velocity.y += gravity * delta
	
	move_and_slide()
	
	pass
