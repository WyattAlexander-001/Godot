extends KinematicBody2D

export var speed := 450.0
export var drag := 14.0

var _target: Player = null
var _velocity := Vector2.ZERO

onready var _flame_main := $Sprite/FlameMain
onready var _flame_left := $Sprite/FlameLeft
onready var _flame_right := $Sprite/FlameRight


func _physics_process(_delta: float) -> void:
	var desired_velocity := Vector2.ZERO
	var direction := _velocity.normalized()

	if _target:
		direction = global_position.direction_to(_target.global_position)
		desired_velocity = direction * speed

	var steering := desired_velocity - _velocity
	_velocity += steering / drag

	rotation = _velocity.angle() + PI / 2
	move_and_slide(_velocity)

	_flame_main.scale = Vector2.ONE * _velocity.length() / speed
	_flame_left.scale = _flame_main.scale * 0.35
	_flame_right.scale = _flame_main.scale * 0.35


func _on_DetectionArea_body_entered(body: Player) -> void:
	_target = body


func _on_DetectionArea_body_exited(_body: Player) -> void:
	_target = null


func _on_HitBox_body_entered(body: Player) -> void:
	if body.has_method("take_damage"):
		body.take_damage()
