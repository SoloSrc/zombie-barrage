extends WeaponModNode
class_name DaggerHitModNode


func can_attach(node: WeaponNode) -> bool:
	return node is DaggerWeapon


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var dagger_weapon: DaggerWeapon = weapon_owner as DaggerWeapon
	dagger_weapon.hits += 1


func _exit_tree() -> void:
	var dagger_weapon: DaggerWeapon = weapon_owner as DaggerWeapon
	dagger_weapon.hits -= 1
