extends Control
class_name HUD

@onready var timer: Label = $Timer

@onready var owner_level: Level = owner as Level

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var minutes: int = int(owner_level.duration_in_secs) / 60
	var seconds: int = int(owner_level.duration_in_secs) % 60
	timer.text = "%02d:%02d" % [minutes, seconds]
