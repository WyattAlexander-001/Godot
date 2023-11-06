extends Node2D

onready var _animator: AnimationPlayer = $AnimationPlayer
onready var _line: Line2D = $Line2D
onready var _hit: Sprite = $hit


func _ready() -> void:
	set_as_toplevel(true)
	_hit.visible = false


func setup(origin, target):
	if not is_inside_tree():
		yield(self, "ready")
	_line.points[0] = origin
	_line.points[1] = target
	_animator.play("shoot")


func hit(collision_point, collision_normal):
	_hit.visible = true
	_hit.position = collision_point
	_hit.rotation = collision_normal.angle() - PI / 2.0
