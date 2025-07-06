extends Camera3D
class_name BirdViewCamera

@export var target: Node3D

var offset: Vector3 = Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	offset = target.global_position - global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position = target.global_position - offset
