extends CharacterBody2D

# Animation
@onready var animation_tree = $AnimationTree
@onready var playback = animation_tree.get("parameters/StateMachine/playback") as AnimationNodeStateMachinePlayback

# Movement
const SPEED = 100.0
const ROLL_MODIFIER = 1.5
var input_vector: Vector2 = Vector2.ZERO

# Processes
func _physics_process(_delta) -> void:
	var state = playback.get_current_node()
	match state:
		"move":
			move_state(_delta)
		"attack":
			attack_state(_delta)
		"roll":
			roll_state(_delta)

# State functions
func move_state(_delta: float) -> void:
	input_vector = Input.get_vector("moveLeft", "moveRight", "moveUp", "moveDown")
	# State and blend positions update
	velocity = input_vector * SPEED
	if input_vector != Vector2.ZERO:
		update_blend_positions(input_vector)
	
	if Input.is_action_just_pressed("attack"):
		playback.travel("attack")
	elif Input.is_action_just_pressed("roll"):
		playback.travel("roll")
	move_and_slide();

func attack_state(_delta: float) -> void:
	pass

func roll_state(_delta: float) -> void:
	move_and_slide();
	velocity = input_vector.normalized() * SPEED * ROLL_MODIFIER

# Animation helper functions
func update_blend_positions(direction_vector: Vector2) -> void:
	animation_tree.set("parameters/StateMachine/move/standState/blend_position", direction_vector)
	animation_tree.set("parameters/StateMachine/move/runState/blend_position", direction_vector)
	animation_tree.set("parameters/StateMachine/attack/blend_position", direction_vector)
	animation_tree.set("parameters/StateMachine/roll/blend_position", direction_vector)
