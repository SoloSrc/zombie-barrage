extends PlayerModNode
class_name LuckModNode


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_owner.luck_modifier += effect

func _exit_tree() -> void:
	player_owner.luck_modifier -= effect
