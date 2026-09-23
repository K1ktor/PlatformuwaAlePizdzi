@tool
extends Area2D
class_name Climb_Wall

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_sprite()
	pass

@export var useRegion := true:
	set(value):
		useRegion = value
		update_sprite()

func update_sprite():
	var sprite = $Sprite2D
	if (useRegion):
		var size = self.scale * 16
		sprite.global_scale = Vector2.ONE * 4
		sprite.region_rect = Rect2(Vector2.ZERO, size)
	pass


func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if (body is Player_Object):
		body.EnterClimbWall(self)
	pass # Replace with function body.


func _on_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if (body is Player_Object):
		body.ExitClimbWall()
	pass # Replace with function body.
