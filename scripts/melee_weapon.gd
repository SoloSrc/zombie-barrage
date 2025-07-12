extends Node3D
class_name MeleeWeapon

@onready var enemy_owner: SkeletonEnemy = owner as SkeletonEnemy


func _on_hurtbox_area_entered(area: Area3D) -> void:
	if not enemy_owner.is_attack_active():
		return
	if area.owner == owner:
		return
	var health: HealthComponent = area.owner.get_node("HealthComponent")
	if health == null:
		return
	health.take_hit(enemy_owner.damage)
