extends MagnetCollectable
class_name XPDrop

@export var xp_amount: float

func _on_area_entered(area: Area3D) -> void:
	if attract_component != null and area.owner == attract_component.target:
		if area.owner is PlayerCharacter:
			var player_target: PlayerCharacter = area.owner
			player_target.xp_track_component.take_xp(xp_amount)
		queue_free()
