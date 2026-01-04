extends ModNode
class_name WeaponModNode


@onready var weapon_owner: WeaponNode = get_parent() as WeaponNode


func can_attach(node: WeaponNode) -> bool:
	return false
