extends Camera2D

# Maximum shake offset on either axis in pixels.
const MAX_OFFSET := 25.0

onready var _shake_timer := $ShakeDuration


# We use the timer and turn physics processing on and off to toggle the shake.
func _ready() -> void:
	set_process(false)
	_shake_timer.connect("timeout", self, "set_process", [false])


func _process(_delta) -> void:
	var random_offset := Vector2(
		rand_range(0.0, MAX_OFFSET), rand_range(0.0, MAX_OFFSET)
	)
	# The timer's progress gives us a multiplier to dampen the shake.
	var timer_progress: float = 1.0 - _shake_timer.time_left / _shake_timer.wait_time
	offset = lerp(random_offset, Vector2.ZERO, timer_progress)


# When touching a mine, we start shaking.
func _on_Mine_body_entered(_body: PhysicsBody2D) -> void:
	# We restart the timer every time in case the player takes damage again
	# before the shake ended.
	_shake_timer.stop()
	_shake_timer.start()
	set_process(true)
