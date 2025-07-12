extends Node3D
class_name FlyingText

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var label_3d: Label3D = $Path3D/PathFollow3D/Label3D

@export var text_color: Color = Color.WHITE
@export var outline_color: Color = Color.BLACK
@export var amount: int = 0
@export var alpha_speed: float = 3.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("fly")
	label_3d.text = str(amount)
	label_3d.modulate = text_color
	label_3d.outline_modulate = outline_color

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var curr_color: Color = label_3d.modulate
	curr_color.a = lerpf(curr_color.a, 0.0, delta)
	label_3d.modulate = curr_color

func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fly":
		queue_free()
