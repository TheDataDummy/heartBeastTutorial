extends CharacterBody2D
@onready var ray_cast_2d = $RayCast2D
@onready var bats_sprite = $bat
@onready var animation_tree = $AnimationTree
@onready var playback = animation_tree.get("parameters/StateMachine/playback") as AnimationNodeStateMachinePlayback
@onready var area_2d = $Area2D

@export var aggro_range  = 64
@export var deaggro_range = 82
@export var SPEED = 50

func _ready() -> void:
	area_2d.area_entered.connect(func(other_area_2d: Area2D):
		queue_free()
	)

func _physics_process(_delta):
	var state = playback.get_current_node()
	var player: = get_player()
	match state:
		"idle": pass
		"chase":
			if player is Player and is_player_in_aggro_range():
				velocity = global_position.direction_to(player.global_position) * SPEED
				bats_sprite.scale.x = sign(velocity.x)
				move_and_slide()

func get_player() -> Player:
	return get_tree().get_first_node_in_group("player")

func can_see_player() -> bool:
	var state = playback.get_current_node()
	var player = get_player()
	if (is_player_in_deaggro_range() and state == "chase") or (is_player_in_aggro_range() and state == "idle"):
		# Check to see if we can see the player
		ray_cast_2d.target_position = player.global_position - global_position
		var can_see_player = not ray_cast_2d.is_colliding()
		return can_see_player

	return false

func is_player_in_aggro_range() -> bool:
	var player: = get_player()
	var result = false
	if player is Player:
		var distance_to_player = global_position.distance_to(player.global_position)
		if distance_to_player < aggro_range:
			result = true
	return result
	
func is_player_in_deaggro_range() -> bool:
	var player: = get_player()
	var result = false
	if player is Player:
		var distance_to_player = global_position.distance_to(player.global_position)
		if distance_to_player < deaggro_range:
			result = true
	return result
