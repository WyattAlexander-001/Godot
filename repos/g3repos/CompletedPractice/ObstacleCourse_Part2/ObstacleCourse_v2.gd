extends YSort

onready var godot := $Course/Godot
onready var finish_area := $Course/Finish
onready var ui_info := $UI/Info
onready var ui_remaining_time := $UI/RemainingTime
onready var timer := $Timer
onready var animation_player := $AnimationPlayer


func _ready() -> void:
	timer.connect("timeout", self, "finish_game")
	finish_area.connect("body_entered", self, "_on_Finish_body_entered")

	set_process(false)
	godot.set_physics_process(false)

	ui_remaining_time.text = get_remaining_time_text(true)

	animation_player.play("course_overview")
	animation_player.queue("start_countdown")


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and animation_player.current_animation == "course_overview":
		animation_player.advance(INF)
		set_process_unhandled_input(false)


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
	var time: float = timer.time_left
	if is_in_ready:
		time = timer.wait_time
	return str(time).pad_decimals(2)


func _on_Finish_body_entered(body: Node) -> void:
	finish_game()
