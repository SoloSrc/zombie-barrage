extends CharacterBody3D

const IDLE_STATE = "idle"
const PISTOL_RUN_STATE = "pistol_run"

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var animation_tree: AnimationTree = $AnimationTree

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction: Vector3 = Vector3.ZERO
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
	if Input.is_action_pressed("move_backward"):
		direction.z += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	
	if direction != Vector3.ZERO:
		animation_tree.set("parameters/Movement/blend_amount", 1.0)
		direction = direction.normalized()
		look_at(global_position + direction)
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		animation_tree.set("parameters/Movement/blend_amount", 0)
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	move_and_slide()

func set_anim_state(state: String) -> void:
	animation_tree.set("parameters/Movement/blend_amount", state)

func get_anim_state() -> String:
	return animation_tree.get("parameters/state/current_state")
