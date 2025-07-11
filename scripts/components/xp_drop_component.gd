extends Node
class_name XPDropComponent

const XP_DROP = preload("res://props/xp_drop.tscn")

@export var xp_amount: float = 50.0
@export var time_to_drop: float = 1.0

@onready var parent_health_component: HealthComponent = owner.get_node("HealthComponent")

var _should_drop: bool = false
var _drop_location: Vector3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(parent_health_component != null)
	parent_health_component.character_death.connect(_on_character_owner_death)

func _process(delta: float) -> void:
	if not _should_drop:
		return
	if time_to_drop > 0.0:
		time_to_drop -= delta
		return
	var xp_drop: XPDrop = XP_DROP.instantiate()
	xp_drop.xp_amount = xp_amount
	xp_drop.transform.origin = _drop_location
	get_tree().root.add_child(xp_drop)
	_should_drop = false

func _on_character_owner_death(dead_owner: Node3D) -> void:
	_drop_location = dead_owner.global_position
	_should_drop = true
