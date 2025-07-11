extends Node
class_name HealthComponent

signal character_death(character: Node3D)

@export var start_health: float = 100.0

@onready var curr_health: float = start_health

func is_alive() -> bool:
	return curr_health > 0.0

func take_hit(damage: float):
	curr_health -= damage
	print(owner.name, " took ", damage, " damage")
	if curr_health <= 0.0:
		character_death.emit(owner)
