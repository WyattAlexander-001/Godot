extends Sprite

export var max_speed := 500.0
export var acceleration := 250.0
export var decceleration := 250.0
export var turn_speed := 5.0

var speed := 0.0

onready var _particles := $Particles2D


func _process(delta: float) -> void:
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
	
	position.x = wrapf(position.x, 0.0, OS.window_size.x)
	position.y = wrapf(position.y, 0.0, OS.window_size.y)

	if Input.is_action_just_pressed("move_up"):
		_particles.emitting = true
	if Input.is_action_just_released("move_up"):
		_particles.emitting = false
	translate(velocity * delta)
