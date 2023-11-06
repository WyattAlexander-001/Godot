extends Camera2D

const MAX_OFFSET := 300.0
const LERP_MULTIPLIER := 5.0


func _physics_process(delta: float) -> void:
	var target_offset := (get_local_mouse_position() / 3.0).clamped(MAX_OFFSET)
	offset = offset.linear_interpolate(target_offset, delta * LERP_MULTIPLIER)
