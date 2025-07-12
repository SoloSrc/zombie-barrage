extends Node3D
class_name MagnetCollectable

@export var was_collected: bool = false

@onready var attract_component: AttractComponent = $AttractComponent
