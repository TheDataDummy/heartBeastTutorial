extends Node2D
@onready var hurtbox = $Hurtbox
const GRASS_EFFECT = preload("res://effects/grassEffect.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hurtbox.area_entered.connect(_on_hurt)

func _on_hurt(other_hitbox: Hitbox) -> void:
	var grass_effect = GRASS_EFFECT.instantiate()
	grass_effect.global_position = global_position
	get_tree().current_scene.add_child(grass_effect)
	queue_free()
