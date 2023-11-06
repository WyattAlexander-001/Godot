extends KinematicBody2D

const MAX_SPEED := 600.0
const DRAG := 10.0

const MAX_ANGULAR_SPEED := PI / 3.0
const ANGULAR_DRAG := 12.0

var _velocity := Vector2.ZERO
var _angular_velocity := 0.0

onready var _flame_main := $Sprite/FlameMain
onready var _flame_left := $Sprite/FlameLeft
onready var _flame_right := $Sprite/FlameRight


func _physics_process(delta: float) -> void:
	var angular_direction := Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var desired_angular_velocity := angular_direction * MAX_ANGULAR_SPEED
	var angular_steering := desired_angular_velocity - _angular_velocity
	_angular_velocity += angular_steering / ANGULAR_DRAG
	rotate(_angular_velocity * delta)

	var move_direction := Input.get_action_strength("move_up") - Input.get_action_strength("move_down")
	var desired_velocity := move_direction * MAX_SPEED * Vector2.RIGHT.rotated(rotation)
	
	var steering := desired_velocity - _velocity
	_velocity += steering / DRAG
	
	_velocity = move_and_slide(_velocity)
	# Updating flames
	var speed_rate := _velocity.length() / MAX_SPEED
	
	_flame_main.scale = Vector2.ONE * speed_rate
	_flame_left.scale = Vector2.ONE * speed_rate * 0.35
	_flame_right.scale = Vector2.ONE * speed_rate * 0.35
