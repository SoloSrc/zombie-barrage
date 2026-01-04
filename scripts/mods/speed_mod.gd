extends PlayerModNode
class_name SpeedModNode


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_owner.speed_modifier *= (1+effect)

func _exit_tree() -> void:
	player_owner.speed_modifier /= (1+effect)
