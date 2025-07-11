extends Node3D
class_name TargetedProjectile

@export var speed: float = 15.0
@export var target: Node3D
@export var hits: int = 1
@export var damage: float = 60.0
@export var character_owner: Node
@export var velocity_normalized: Vector3

@onready var _ignored_owner_once: bool = false

func _process(_delta: float) -> void:
	if hits < 1:
		queue_free()

func _physics_process(delta: float) -> void:
	look_at(global_position + velocity_normalized)
	global_position += velocity_normalized * speed * delta

func _on_hurtbox_area_entered(area: Area3D) -> void:
	if area.owner == character_owner and not _ignored_owner_once:
		_ignored_owner_once = true
		return
	var health: HealthComponent = area.owner.get_node("HealthComponent")
	if health == null:
		return
	health.take_hit(damage)
	hits -= 1
