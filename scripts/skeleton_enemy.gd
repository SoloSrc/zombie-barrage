extends CharacterBody3D
class_name SkeletonEnemy

const START_DAMAGE = 50.0

var damage: float = START_DAMAGE

@onready var animation_tree: AnimationTree = $AnimationTree
var velocity_computed: Vector3

func _physics_process(delta: float) -> void:
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
	
