extends Area3D
class_name Magnet

@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var player_owner: PlayerCharacter = owner as PlayerCharacter

@export var magnet_radius: float :
	set(value):
		var sphere: SphereShape3D = collision_shape_3d.shape as SphereShape3D
		sphere.radius = value
		magnet_radius = value

func _ready() -> void:
	assert(player_owner != null)
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area3D):
	if not player_owner.health_component.is_alive():
		return
	if not area.owner is MagnetCollectable:
		return
	var collectable: MagnetCollectable = area.owner as MagnetCollectable
	if collectable.was_collected:
		return
	collectable.attract_component.go_to(player_owner)
