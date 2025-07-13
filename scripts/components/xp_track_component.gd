extends Node
class_name XPTrackComponent

signal player_got_xp(player: PlayerCharacter)
signal player_leveled_up(player: PlayerCharacter)

@export var xp_modifier: float = 1.0

@onready var player_owner: PlayerCharacter = owner as PlayerCharacter
@onready var level: int = 1
@onready var current_xp: float = 0.0

func get_xp_required() -> float:
	if level < 1:
		return 0
	return (2 ** (level - 1)) * 250

func take_xp(amount: float) -> void:
	current_xp += amount * xp_modifier
	if current_xp >= get_xp_required():
		level += 1
		current_xp = 0
		player_leveled_up.emit(player_owner)
	player_got_xp.emit(player_owner)
