extends Node
class_name Level

const GAME_CONFIG = preload("res://config/game_config.tres")

@onready var hud: HUD = $Hud
@onready var game_over_screen: Control = $GameOver
@onready var game_over_timer: Timer = $GameOverTimer
@onready var mod_selection: ModSelection = $ModSelection
@onready var pause_screen: PauseScreen = $PauseScreen


# level statistics
@export var player: PlayerCharacter
@export var duration_in_secs: float = 0.0
@export var kills: int = 0
@export var config: GameConfig = GAME_CONFIG


func _ready() -> void:
	player = get_tree().get_first_node_in_group("players")
	player.health_component.character_death.connect(on_player_death)
	player.xp_track_component.player_leveled_up.connect(_on_player_leveled_up)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player.health_component.is_alive():
		duration_in_secs += delta
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = true
		pause_screen.show()


func on_enemy_death(_character: Node3D):
	kills += 1

func on_player_death(_player: Node3D) -> void:
	game_over_timer.start()

func _on_game_over_timer_timeout() -> void:
	get_tree().paused = true
	hud.hide()
	game_over_screen.show()

func _on_player_leveled_up(_player: PlayerCharacter) -> void:
	get_tree().paused = true
	mod_selection.roll()
	mod_selection.show()


func _on_mod_selection_mod_selected(mod: ModNode) -> void:
	player.add_child(mod)
	mod_selection.hide()
	get_tree().paused = false
