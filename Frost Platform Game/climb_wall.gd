extends Area2D
class_name Climb_Wall

@onready var CollisionShape : CollisionShape2D = $CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if (body is Player_Object):
		body.EnterClimbWall(self)
	pass # Replace with function body.


func _on_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if (body is Player_Object):
		body.ExitClimbWall()
	pass # Replace with function body.
