extends Control

onready var _time_label := $TimeRect/Label


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_time_label.text = "And this one tells time:\n{hour}:{minute}:{second}".format(
		OS.get_time()
	)
