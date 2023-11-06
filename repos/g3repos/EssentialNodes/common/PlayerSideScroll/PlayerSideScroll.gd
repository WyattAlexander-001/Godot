extends KinematicBody2D

const FLOOR_NORMAL := Vector2.UP

const SNAP_DIRECTION := Vector2.DOWN
const SNAP_VECTOR_LENGTH := 32.0

const STOP_ON_SLOPE := true
const MAX_SLIDES := 4
const MAX_SLOPE_ANGLE := deg2rad(46)

export var speed := 600.0
export var jump_strength := 1400.0
export var gravity := 4500.0

var _velocity := Vector2.ZERO
var _snap_vector := SNAP_DIRECTION * SNAP_VECTOR_LENGTH

onready var _pivot: Node2D = $PlayerSideSkin
onready var _anim_player: AnimationPlayer = $PlayerSideSkin/AnimationPlayer
onready var _start_scale := _pivot.scale


func _physics_process(delta: float) -> void:
	# Movement
	var horizontal_direction := (
		Input.get_action_strength("move_right")
		- Input.get_action_strength("move_left")
	)

	var is_jumping := Input.is_action_just_pressed("jump") and is_on_floor()
	var is_jump_cancelled := Input.is_action_just_released("jump") and _velocity.y < 0.0
	var is_landing := _snap_vector == Vector2.ZERO and is_on_floor()

	_velocity.x = horizontal_direction * speed
	_velocity.y += gravity * delta

	if is_jumping:
		_velocity.y = -jump_strength
		_snap_vector = Vector2.ZERO
	elif is_jump_cancelled:
		_velocity.y = 0.0
	elif is_landing:
		_snap_vector = SNAP_DIRECTION * SNAP_VECTOR_LENGTH

	_velocity = move_and_slide_with_snap(
		_velocity, _snap_vector, FLOOR_NORMAL, STOP_ON_SLOPE, MAX_SLIDES, MAX_SLOPE_ANGLE
	)

	# Visuals
	if not is_zero_approx(horizontal_direction):
		_pivot.scale.x = sign(horizontal_direction) * _start_scale.x

	if is_jumping:
		_anim_player.play("jump")
	elif is_on_floor():
		if not is_zero_approx(horizontal_direction) and not is_on_wall():
			_anim_player.play("run")
		else:
			_anim_player.play("idle")
	elif _velocity.y > 0.0:
		_anim_player.play("fall")


func get_look_direction() -> float:
	return sign(_pivot.scale.x)
