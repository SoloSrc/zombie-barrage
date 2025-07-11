extends Node
class_name XPTrackComponent

@onready var current_xp: float = 0.0

func take_xp(amount: float) -> void:
	current_xp += amount
	print(owner.name, " got ", amount, " XP")
