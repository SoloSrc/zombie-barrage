extends Node
class_name SpinComponent

@export var rotation_speed: float = -8.0
@onready var node3d_parent: Node3D = get_parent() as Node3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	node3d_parent.rotate_x(rotation_speed * delta)
