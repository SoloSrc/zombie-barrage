extends CharacterBody3D
class_name SkeletonEnemy

const START_DAMAGE = 50.0

var damage: float = START_DAMAGE

var weapon_range: float = 2.0

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var health_component: HealthComponent = $HealthComponent
@onready var animation_player: AnimationPlayer = $Skeleton_Minion/AnimationPlayer

var velocity_computed: Vector3

func _ready() -> void:
	animation_tree.set("parameters/Transition/transition_request", "Alive")

func _process(_delta: float) -> void:
	if not health_component.is_alive() and not is_curr_anim_state_dead():
		animation_tree.set("parameters/Transition/transition_request", "Dead")
	elif is_curr_anim_state_dead() and is_death_anim_finished():
		print(animation_tree["parameters/DeathAnimation/current_length"])
		queue_free()

func _physics_process(delta: float) -> void:
	if not health_component.is_alive():
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
	var pos: float = animation_tree.get("parameters/SliceDiagonalAnimation/current_position")
	return pos >= 0.33 and pos < 0.51

func is_curr_anim_state_dead():
	return animation_tree.get("parameters/Transition/current_state") == "Dead"

func is_death_anim_finished() -> bool:
	var curr_position: float = animation_tree["parameters/DeathAnimation/current_position"]
	return curr_position >= animation_tree["parameters/DeathAnimation/current_length"]
