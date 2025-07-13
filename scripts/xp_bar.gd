extends ProgressBar
class_name XPBar

@onready var label: Label = $Panel/Label

var player: PlayerCharacter
var xp_track_component: XPTrackComponent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("players") as PlayerCharacter
	xp_track_component = player.xp_track_component
	_on_player_got_xp(player)
	xp_track_component.player_got_xp.connect(_on_player_got_xp)

func _on_player_got_xp(_player: PlayerCharacter):
	max_value = xp_track_component.get_xp_required()
	value = xp_track_component.current_xp
	label.text = "Lv " + str(xp_track_component.level)
