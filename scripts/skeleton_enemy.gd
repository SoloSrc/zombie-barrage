extends CharacterBody3D
class_name SkeletonEnemy

const START_SPEED = 2.5

var target: CharacterBody3D
var movement_delta: float
var speed: float = START_SPEED

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
@onready var animation_tree: AnimationTree = $AnimationTree


func _process(_delta: float) -> void:
	navigation_agent.set_target_position(target.global_position)

func _physics_process(delta: float) -> void:
	# Do not query when the map has never synchronized and is empty.
	if NavigationServer3D.map_get_iteration_id(navigation_agent.get_navigation_map()) == 0:
		return
	if navigation_agent.is_navigation_finished():
		return
	
	movement_delta = speed * delta
	var next_path_position: Vector3 = navigation_agent.get_next_path_position()
	var new_velocity: Vector3 = global_position.direction_to(next_path_position) * movement_delta
	
	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	move_and_slide()

func _on_velocity_computed(safe_velocity: Vector3) -> void:
	if safe_velocity != Vector3.ZERO:
		animation_tree.set("parameters/Movement/blend_amount", 1.0)
	else:
		animation_tree.set("parameters/Movement/blend_amount", 0.0)
	look_at(global_position + safe_velocity)
	global_position = global_position.move_toward(global_position + safe_velocity, movement_delta)
