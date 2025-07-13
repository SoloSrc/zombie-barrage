extends Node
class_name HealthComponent

signal character_damage(amount: float)
signal character_death(character: Node3D)

@export var max_health: float = 100.0
@onready var curr_health: float = max_health

func is_alive() -> bool:
	return curr_health > 0.0

func take_hit(damage: float):
	if curr_health <= 0.0:
		return
	curr_health -= damage
	character_damage.emit(damage)
	if curr_health <= 0.0:
		character_death.emit(owner)
