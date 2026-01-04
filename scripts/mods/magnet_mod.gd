extends PlayerModNode
class_name MagnetModNode


func _ready() -> void:
	player_owner.magnet.magnet_radius *= (1+effect)


func _exit_tree() -> void:
	player_owner.magnet.magnet_radius /= (1+effect)
