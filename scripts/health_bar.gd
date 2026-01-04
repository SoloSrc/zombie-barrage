extends ProgressBar
class_name HealthBar

@onready var damage_bar: ProgressBar = $DamageBar
@onready var timer: Timer = $Timer

var player: PlayerCharacter
var health_component: HealthComponent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("players") as PlayerCharacter
	health_component = player.health_component
	max_value = health_component.max_health
	value = health_component.max_health
	damage_bar.max_value = health_component.max_health
	damage_bar.value = health_component.max_health
	health_component.character_damage.connect(_on_player_took_damage)
	health_component.character_max_health_changed.connect(_on_player_changed_max_health)

func _on_player_took_damage(amount: float):
	timer.start()
	value -= amount

func _on_timer_timeout() -> void:
	damage_bar.value = value

func _on_player_changed_max_health(new_max: float, _offset: float):
	max_value = new_max
	damage_bar.max_value = new_max
