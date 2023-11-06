extends Control

onready var time_label: Label = $Time


func _process(_delta: float) -> void:
	var time := OS.get_ticks_msec() / 1000.0
	time_label.text = "%.1f" % stepify(time, 0.1)
