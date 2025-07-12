extends Node3D
class_name FlyingText

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var label_3d: Label3D = $Path3D/PathFollow3D/Label3D

@export var amount: int = 0
@export var alpha_speed: float = 3.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("fly")
	label_3d.text = str(amount)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var color: Color = label_3d.modulate
	color.a = lerpf(color.a, 0.0, delta)
	label_3d.modulate = color

func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fly":
		queue_free()
