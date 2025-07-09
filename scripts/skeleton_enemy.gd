extends CharacterBody3D
class_name SkeletonEnemy

const START_DAMAGE = 50.0
const START_HEALTH = 100.0

var damage: float = START_DAMAGE
var health: float = START_HEALTH

var weapon_range: float = 2.0

@onready var animation_tree: AnimationTree = $AnimationTree
var velocity_computed: Vector3

func _physics_process(delta: float) -> void:
	if health <= 0.0:
		return
	velocity_computed.y = 0
	velocity = velocity_computed
	if velocity_computed != Vector3.ZERO:
		look_at(global_position + velocity_computed)
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()

func _on_velocity_computed(safe_velocity: Vector3) -> void:
	if safe_velocity != Vector3.ZERO:
		animation_tree.set("parameters/Movement/blend_amount", 1.0)
	else:
		animation_tree.set("parameters/Movement/blend_amount", 0.0)
	velocity_computed = safe_velocity

func _on_target_within_range(_target: PlayerCharacter):
	if not is_attacking():
		animation_tree.set("parameters/Attack/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func is_attacking() -> bool:
	return animation_tree.get("parameters/Attack/active")

func is_attack_active() -> bool:
	if not is_attacking():
		return false
	var pos: float = animation_tree.get("parameters/SliceDiagonal/current_position")
	return pos >= 0.33 and pos < 0.51
