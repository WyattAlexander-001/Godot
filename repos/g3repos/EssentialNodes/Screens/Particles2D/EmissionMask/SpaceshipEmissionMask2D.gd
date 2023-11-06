extends Sprite

export var max_speed := 700.0
export var acceleration := 250.0
export var decceleration := 250.0
export var turn_speed := 5.0
export var turbo_speed := 1300.0

var speed := 0.0

onready var _trail_left := $TrailParticles2DLeft
onready var _trail_right := $TrailParticles2DRight
onready var _aura := $AuraParticles2D


func _process(delta: float) -> void:
	if not is_equal_approx(speed, turbo_speed):
		if Input.is_action_pressed("move_up"):
			speed += acceleration * delta
		else:
			speed -= decceleration * delta
		speed = clamp(speed, 0.0, max_speed)
	
	if Input.is_action_pressed("move_left"):
		rotate(-turn_speed * delta)
	if Input.is_action_pressed("move_right"):
		rotate(turn_speed * delta)
	var velocity := (Vector2.UP * speed).rotated(rotation)

	translate(velocity * delta)

	_trail_left.emitting = Input.is_action_pressed("move_up")
	_trail_right.emitting = Input.is_action_pressed("move_up")

	# Turbo effect
	if Input.is_action_just_pressed("turbo"):
		speed = turbo_speed
		_aura.emitting = true
	elif Input.is_action_just_released("turbo"):
		speed = max_speed
		_aura.emitting = false
	position.x = wrapf(position.x, 0.0, OS.window_size.x)
	position.y = wrapf(position.y, 0.0, OS.window_size.y)
