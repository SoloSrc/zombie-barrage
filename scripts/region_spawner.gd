extends Timer
class_name RegionSpawner

const SKELETON_MINION = preload("res://characters/skeleton_minion.tscn")

@export var player: PlayerCharacter
@export var regions: Array[NavigationRegion3D]

var region_rids: Array[RID]
var last_region_idx: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	region_rids = []
	for region in regions:
		region_rids.append(region.get_rid())
	last_region_idx = -1

func _on_timeout() -> void:
	var next_region_idx: int = (last_region_idx + 1) % region_rids.size()
	var node: SkeletonEnemy = SKELETON_MINION.instantiate()
	var origin: Vector3 = player.global_position
	while get_viewport().get_camera_3d().is_position_in_frustum(origin):
		origin = NavigationServer3D.region_get_random_point(region_rids[next_region_idx], 0, true)
	node.transform.origin = origin
	owner.add_child(node)
