extends Node2D

onready var godot := $Course/Godot
onready var ui_remaining_time := $CanvasLayer/RemainingTime
onready var timer := $Timer
onready var finish_area := $Course/FinishLine
onready var info_label := $CanvasLayer/Info


func _ready() -> void:
	godot.set_physics_process(false)
	ui_remaining_time.text = get_time_as_text(timer.wait_time)
	# This turns off calls to _process() every frame for this node.
	set_process(false)

	finish_area.connect("body_entered", self, "_on_Finish_body_entered")
	timer.connect("timeout", self, "finish_game")


func _process(delta: float) -> void:
	# The Timer.time_left variable tells us the timer's remaining time.
	ui_remaining_time.text = get_time_as_text(timer.time_left)


func start() -> void:
	godot.set_physics_process(true)
	timer.start()
	# Once we started the timer, we can reactivate calls to _process() to update
	# the text every frame.
	set_process(true)


func finish_game() -> void:
	set_process(false)
	godot.set_physics_process(false)
	info_label.rect_scale = Vector2.ONE
	info_label.get_font("font").size = 128
	# We ensure that the label is visible.
	info_label.show()
	info_label.text = "You lost!"
	# The variables below are there just to help you read the code. We'll
	# sometimes use variables to put a name on an otherwise less explicit
	# instruction.
	var player_has_won := timer.time_left > 0.0
	if player_has_won:
		var player_time: float = timer.wait_time - timer.time_left
		info_label.text = "You won!\nTime: " + get_time_as_text(player_time)
	timer.stop()


func get_time_as_text(time: float) -> String:
	return str(time).pad_decimals(2).pad_zeros(2)


# We can't directly connect the body_entered signal to the finish_game()
# function because the body_entered signal requires a callback with a `body`
# parameter.
#
# That's why we need this function.
func _on_Finish_body_entered(body: Node) -> void:
	finish_game()
