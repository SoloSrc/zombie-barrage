extends Control
class_name PauseScreen


var _released: bool = false
var unpaused: bool = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_released("pause"):
		_released = true
		unpaused = false
	if Input.is_action_pressed("pause") and _released and not unpaused:
		hide()
		get_tree().paused = false
		unpaused = true
		_released = false
