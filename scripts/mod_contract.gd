extends PanelContainer
class_name ModContract

signal signed(id: int)

@export var id: int
@export var data: ModData

@onready var weapon_name_node: Label = $VSplitContainer/WeaponUpgrade
@onready var mod_name_node: Label = $VSplitContainer/ModName
@onready var description_node: Label = $VSplitContainer/HumanDescription


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if data.weapon_name == "":
		weapon_name_node.text = "Character Upgrade"
	else:
		weapon_name_node.text = data.weapon_name
	mod_name_node.text = data.mod_name
	description_node.text = data.description


func _on_button_pressed() -> void:
	signed.emit(id)
