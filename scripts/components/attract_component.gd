extends Node
class_name AttractComponent

const MAGNET_PATH = preload("res://props/magnet_path.tscn")

@export var target: Node3D
@export var speed: float = 7.0

@onready var owner_collectable: MagnetCollectable = owner as MagnetCollectable
var path_follow: PathFollow3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if target == null or path_follow == null:
		return
	if path_follow.progress_ratio < 1.0:
		path_follow.progress += speed * delta
		owner_collectable.global_position = path_follow.global_position
		return
	var distance: Vector3 = (target.global_position - owner_collectable.global_position).normalized()
	owner_collectable.global_position += distance * speed * delta

func go_to(new_target: Node3D) -> void:
	target = new_target
	var magnet_path: Path3D = MAGNET_PATH.instantiate()
	magnet_path.transform.origin = owner_collectable.global_position
	owner_collectable.get_tree().root.add_child(magnet_path)
	owner_collectable.was_collected = true
	path_follow = magnet_path.path_follow_3d
	
	var to_target: Vector3 = (target.global_position - owner_collectable.global_position).normalized()
	magnet_path.look_at(magnet_path.global_position + to_target)
