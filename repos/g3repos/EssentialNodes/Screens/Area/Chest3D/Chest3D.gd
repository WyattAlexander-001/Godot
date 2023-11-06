extends Spatial

var _state := ["close", "open"]

onready var _area: Area = $Area
onready var _animation_player: AnimationPlayer = $Chest/AnimationPlayer


func _unhandled_input(event: InputEvent) -> void:
	if _animation_player.is_playing():
		return
	if event.is_action_pressed("interact"):
		for body in _area.get_overlapping_bodies():
			if body is Player3D:
				toggle_open()


func toggle_open() -> void:
	_state.push_back(_state.pop_front())
	_animation_player.play(_state.front())
