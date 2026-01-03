extends Control
class_name ModSelection

signal mod_selected(mod: ModNode)

@export var options: Array[ModData]

@onready var mod_option_container: HBoxContainer = $MarginContainer/CenterContainer/VSplitContainer/ModOptionContainer
@onready var level: Level = owner as Level

const MOD_CONTRACT = preload("res://ui/mod_contract.tscn")

var player: PlayerCharacter

func _ready() -> void:
	player = get_tree().get_first_node_in_group("players") as PlayerCharacter

func roll() -> void:
	options.clear()
	for child in mod_option_container.get_children():
		child.queue_free()
	var draft: ModDraft = ModDraft.new(player, level.config)
	options = draft.roll()
	var idx = 0
	for option in options:
		var mod_contract_ui = MOD_CONTRACT.instantiate()
		mod_contract_ui.data = option
		mod_contract_ui.id = idx
		mod_option_container.add_child(mod_contract_ui)
		mod_contract_ui.signed.connect(_on_mod_contract_signed)
		idx += 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_mod_contract_signed(idx: int):
	print("MOD %d was signed", idx)
	var selected: ModData = options[idx]
	var mod_node: ModNode = selected.mod_scene.instantiate()
	mod_node.effect = selected.effect
	mod_node.rarity = selected.rarity
	mod_selected.emit(mod_node)
