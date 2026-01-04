extends PlayerModNode
class_name CooldownModNode


func _ready() -> void:
	player_owner.cooldown_modifier *= (1-effect)


func _exit_tree() -> void:
	player_owner.cooldown_modifier /= (1-effect)
