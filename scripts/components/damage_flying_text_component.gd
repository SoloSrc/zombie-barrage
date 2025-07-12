extends Node3D
class_name DamageFlyingTextComponent

const FLYING_TEXT = preload("res://props/flying_text.tscn")

func _ready() -> void:
	var health_component: HealthComponent = owner.find_child("HealthComponent") as HealthComponent
	health_component.character_damage.connect(_on_character_damage)

func _on_character_damage(amount: float) -> void:
	var flying_text: FlyingText = FLYING_TEXT.instantiate()
	flying_text.transform.origin = global_position
	flying_text.amount = int(amount)
	get_tree().root.add_child(flying_text)
