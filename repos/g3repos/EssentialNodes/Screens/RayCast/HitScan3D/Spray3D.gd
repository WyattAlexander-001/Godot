extends Spatial
onready var _animator: AnimationPlayer = $AnimationPlayer
onready var _shot_pivot: Spatial = $ShotPivot
onready var _ricochet_pivot: Spatial = $RicochetPivot


func _ready() -> void:
	set_as_toplevel(true)
	_ricochet_pivot.visible = false


func setup(origin: Vector3, target: Vector3) -> void:
	if not is_inside_tree():
		yield(self, "ready")
	_shot_pivot.global_transform.origin = origin
	_shot_pivot.look_at(target, Vector3.UP)
	_shot_pivot.scale.z = origin.distance_to(target)
	_animator.play("shoot")


func hit(collision_point: Vector3, collision_normal: Vector3, shot_normal: Vector3) -> void:
	_ricochet_pivot.visible = true
	_ricochet_pivot.global_transform.origin = collision_point
	_ricochet_pivot.look_at(collision_point + collision_normal, shot_normal.cross(collision_normal))
