extends Node2D

onready var counter_label := $CounterLabel
onready var counter_button := $Button
onready var timer := $Timer

func _ready() -> void:
	pause(true)
	counter_button.connect("toggled", self, "_on_Button_toggled")
	timer.connect("timeout", self, "_on_Timer_timeout")


func _on_Button_toggled(toggle: bool) -> void:
	pause(not toggle)
	if toggle:
		for node in get_tree().get_nodes_in_group("measurer"):
			node.position.y = 0
			node.velocity = Vector2()
		timer.start()
	else:
		timer.stop()
		counter_label.text = "0"

func pause(paused: bool) -> void:
	for node in get_tree().get_nodes_in_group("measurer"):
		node.set_physics_process(not paused)


func _on_Timer_timeout() -> void:
	pause(true)

func _process(_delta: float) -> void:
	if not timer.is_stopped():
		counter_label.text = str(timer.time_left)
