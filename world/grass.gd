extends Node2D
@onready var area_2d = $Area2D
const GRASS_EFFECT = preload("res://effects/grassEffect.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_2d.area_entered.connect(_on_area_2d_area_entered)

func _on_area_2d_area_entered(_enteringArea: Area2D) -> void:
	var grass_effect = GRASS_EFFECT.instantiate()
	grass_effect.global_position = global_position
	get_tree().current_scene.add_child(grass_effect)
	queue_free()
