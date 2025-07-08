extends Path3D
class_name SpawnPath

@export var player: PlayerCharacter

@onready var spawn_path_follow_3d: PathFollow3D = $SpawnPathFollow3D
const SKELETON_MINION = preload("res://characters/skeleton_minion.tscn")

func _on_spawn_timer_timeout() -> void:
	var node: SkeletonEnemy = SKELETON_MINION.instantiate()
	spawn_path_follow_3d.progress_ratio = randf()
	node.transform.origin = spawn_path_follow_3d.global_position
	node.target = player
	get_parent().add_child(node)
