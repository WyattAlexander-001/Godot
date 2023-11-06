extends StaticBody

signal pressed

onready var _animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	connect("input_event", self, "_on_input_event")


func _on_input_event(_camera, event: InputEvent, _click_position, _click_normal, _shape_idx) -> void:
	# Ignore anything but clicks, and only activate if not already pushed.
	if not event.is_action_pressed("click") or _animation_player.assigned_animation == "push":
		return

	emit_signal("pressed")
	_animation_player.play("push")


func reset() -> void:
	_animation_player.play("reset")
