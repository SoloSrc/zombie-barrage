extends NavigationAgent3D
class_name PursuingAgent

signal within_range(target: PlayerCharacter)

@export var start_speed = 2.0

@onready var speed: float = start_speed
@onready var enemy_owner: SkeletonEnemy = owner as SkeletonEnemy

var target: PlayerCharacter

func _ready() -> void:
	velocity_computed.connect(enemy_owner._on_velocity_computed)
	within_range.connect(enemy_owner._on_target_within_range)

func _process(_delta: float) -> void:
	var players: Array[Node] = get_tree().get_nodes_in_group("players")
	var min_distance: float = 1.79769e308
	var closest_player: PlayerCharacter = null
	for player in players:
		var character: PlayerCharacter = player as PlayerCharacter
		var dist: float = (character.global_position - enemy_owner.global_position).length()
		if closest_player == null || dist < min_distance:
			closest_player = character
			min_distance = dist
	if closest_player != null:
		set_target_position(closest_player.global_position)
		target = closest_player
	
	if min_distance < enemy_owner.weapon_range:
		within_range.emit(closest_player)

func _physics_process(_delta: float) -> void:
	# Do not query when the map has never synchronized and is empty.
	if NavigationServer3D.map_get_iteration_id(get_navigation_map()) == 0:
		return
	if is_navigation_finished():
		return
	
	if (target.global_position - enemy_owner.global_position).length() <= enemy_owner.weapon_range:
		return
	
	var next_path_position: Vector3 = get_next_path_position()
	var new_velocity: Vector3 = enemy_owner.global_position.direction_to(next_path_position) * speed
	
	if avoidance_enabled:
		set_velocity(new_velocity)
	else:
		enemy_owner._on_velocity_computed(new_velocity)
