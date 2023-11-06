extends Area

export var max_speed := 4.0

var _velocity := Vector3.ZERO

func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")


func _process(delta: float) -> void:
	var attractors := get_overlapping_areas()

	if attractors:
		var desired_velocity: Vector3 = (
			(attractors[0].global_transform.origin - global_transform.origin).normalized()
			* max_speed
		)
		var steering := desired_velocity - _velocity
		_velocity += steering / 14.0
	else:
		_velocity = Vector3.ZERO

	global_transform.origin += _velocity * delta


func _on_body_entered(_body: Node) -> void:
	queue_free()
