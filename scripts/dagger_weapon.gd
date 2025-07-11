extends Node3D
class_name DaggerWeapon

const DAGGER_PROJECTILE = preload("res://weapons/dagger_projectile.tscn")

@export var cooldown_in_secs: float = 2.0

@onready var in_range: Dictionary[NodePath,SkeletonEnemy] = {}
@onready var player_owner: PlayerCharacter = get_parent() as PlayerCharacter

var cooldown_countdown: float = 0.0

func _process(delta: float) -> void:
	if not player_owner.health_component.is_alive():
		return
	if cooldown_countdown > 0.0:
		cooldown_countdown -= delta
		return
	
	var closest_enemy: SkeletonEnemy = _find_closest_enemy_in_range()
	if closest_enemy == null:
		return
	var projectile: TargetedProjectile = DAGGER_PROJECTILE.instantiate()
	projectile.character_owner = get_parent()
	projectile.target = closest_enemy
	projectile.transform.origin = global_position
	projectile.transform.origin.y += 1.1 # add half the height of a character
	projectile.velocity_normalized = (closest_enemy.global_position - global_position).normalized()
	get_tree().root.add_child(projectile)
	cooldown_countdown = cooldown_in_secs

func _find_closest_enemy_in_range() -> SkeletonEnemy:
	var closest_enemy: SkeletonEnemy = null
	var min_dist: float = 1.79769e308
	for path in in_range.keys():
		var enemy: SkeletonEnemy = in_range[path]
		if enemy == null or not enemy.health_component.is_alive():
			in_range.erase(path)
			continue
		var dist: float = (enemy.global_position - global_position).length()
		if closest_enemy == null || dist < min_dist:
			closest_enemy = enemy
			min_dist = dist
	return closest_enemy

func _on_range_area_entered(area: Area3D) -> void:
	if not area.owner.is_in_group("enemies"):
		return
	var enemy: SkeletonEnemy = area.owner as SkeletonEnemy
	var key: NodePath = enemy.get_path()
	in_range[key] = enemy


func _on_range_area_exited(area: Area3D) -> void:
	if area.owner == null:
		return
	if not area.owner.is_in_group("enemies"):
		return
	var enemy: SkeletonEnemy = area.owner as SkeletonEnemy
	var key: NodePath = enemy.get_path()
	in_range.erase(key)
