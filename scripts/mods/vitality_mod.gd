extends PlayerModNode
class_name VitalityModNode


func _ready() -> void:
	player_owner.health_component.change_max_health(effect)


func _exit_tree() -> void:
	player_owner.health_component.change_max_health(-effect)
