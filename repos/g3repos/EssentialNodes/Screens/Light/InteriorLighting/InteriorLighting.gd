extends Spatial

onready var _gi_probe: GIProbe = $GIProbe


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_gi_probe"):
		_gi_probe.visible = not _gi_probe.visible
