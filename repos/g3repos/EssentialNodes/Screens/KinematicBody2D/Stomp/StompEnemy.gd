extends KinematicBody2D

const FLOOR_NORMAL := Vector2.UP
const SNAP_VECTOR := Vector2.DOWN * 32.0

export var speed := 300.0
export var gravity := 4500.0

var _velocity := Vector2.ZERO
var _horizontal_direction := -1

onready var _sprites := $Sprites
onready var _animation_player: AnimationPlayer = $AnimationPlayer


func _physics_process(delta: float) -> void:
	_velocity = move_and_slide_with_snap(_velocity, SNAP_VECTOR, FLOOR_NORMAL, true, 4, deg2rad(46))
	if is_on_wall():
		_horizontal_direction *= -1

	_velocity.x = _horizontal_direction * speed
	_velocity.y += gravity * delta
	
	_sprites.scale.x = _horizontal_direction

func take_damage():
	if not is_physics_processing():
		return
	set_physics_process(false)
	_animation_player.play("Die")
	
