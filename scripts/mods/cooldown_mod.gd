extends PlayerModNode
class_name CooldownModNode


func _ready() -> void:
	player_owner.cooldown_modifier -= effect


func _exit_tree() -> void:
	player_owner.cooldown_modifier += effect
