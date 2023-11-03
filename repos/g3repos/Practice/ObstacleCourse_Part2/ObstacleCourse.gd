extends YSort


onready var godot: KinematicBody2D = $Course/Godot
onready var finish_area: Area2D = $Course/Finish
onready var ui_info: Label = $UI/Info
onready var ui_remaining_time: Label = $UI/RemainingTime
onready var timer: Timer = $Timer
onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	timer.connect("timeout", self, "finish_game")
	finish_area.connect("body_entered", self, "_on_Finish_body_entered")

	set_process(false)
	godot.set_physics_process(false)

	ui_remaining_time.text = get_remaining_time_text(true)


func _process(delta: float) -> void:
	ui_remaining_time.text = get_remaining_time_text(false)


func start() -> void:
	set_process(true)
	godot.set_physics_process(true)
	timer.start()


func finish_game() -> void:
	animation_player.play("finish_game")
	ui_info.text = "You lost!"
	if timer.time_left > 0.0:
		ui_info.text = "You won!\nRemaining time: " + get_remaining_time_text(false)
	set_process(false)
	godot.set_physics_process(false)
	timer.stop()


func get_remaining_time_text(is_in_ready: bool) -> String:
	var time := timer.time_left
	if is_in_ready:
		time = timer.wait_time
	return str(time).pad_decimals(2)


func _on_Finish_body_entered(body: Node) -> void:
	finish_game()
