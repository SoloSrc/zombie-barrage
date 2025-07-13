extends Node
class_name Level

@onready var hud: HUD = $Hud
@onready var game_over_screen: Control = $GameOver
@onready var game_over_timer: Timer = $GameOverTimer

# level statistics
@export var player: PlayerCharacter
@export var duration_in_secs: float = 0.0
@export var kills: int = 0

func _ready() -> void:
	player = get_tree().get_first_node_in_group("players")
	player.health_component.character_death.connect(on_player_death)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player.health_component.is_alive():
		duration_in_secs += delta

func on_enemy_death(_character: Node3D):
	kills += 1

func on_player_death(_player: Node3D) -> void:
	game_over_timer.start()

func _on_game_over_timer_timeout() -> void:
	get_tree().paused = true
	hud.hide()
	game_over_screen.show()
