extends Node
class_name Level

# level statistics
@export var duration_in_secs: float = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	duration_in_secs += delta
