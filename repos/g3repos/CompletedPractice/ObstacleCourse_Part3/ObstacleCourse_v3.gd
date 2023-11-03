extends YSort

# The underscore before the variable name is a convention meaning that it should
# not be used outside of this script.
var _savegame: SaveGame = null

onready var obstacle_course := $ViewportsRow/ViewportContainer/Viewport/Course
onready var finish_area := obstacle_course.get_node("Finish")

onready var ui_layer := $UI
onready var ui_info := ui_layer.get_node("Info")
onready var ui_remaining_time := ui_layer.get_node("RemainingTime")
onready var timer := $Timer
onready var animation_player := $AnimationPlayer

onready var split_viewports_container := $ViewportsRow
onready var viewport_overview_container := $OverviewViewportContainer

onready var viewport_overview := $OverviewViewportContainer/Viewport
onready var viewport_left := split_viewports_container.get_node("ViewportContainer/Viewport")
onready var viewport_right := split_viewports_container.get_node("ViewportContainer2/Viewport")

onready var players := [obstacle_course.get_node("PlayerCharacter"), obstacle_course.get_node("PlayerCharacter2")]
onready var ui_customize_character := $Menus/UICustomizeCharacter


func _ready() -> void:
	timer.connect("timeout", self, "finish_game", [null])
	finish_area.connect("body_entered", self, "_on_Finish_body_entered")

	set_process(false)
	for player in players:
		player.set_physics_process(false)

	ui_remaining_time.text = get_remaining_time_text(true)

	animation_player.play("course_overview")
	animation_player.queue("start_countdown")
	
	viewport_right.world_2d = viewport_left.world_2d
	viewport_overview.world_2d = viewport_right.world_2d

	_savegame = SaveGame.load_savegame()
	if not _savegame:
		_create_savegame()
	players[0].settings = _savegame.player_1
	players[1].settings = _savegame.player_2
	ui_customize_character.setup(_savegame)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and animation_player.current_animation == "course_overview":
		animation_player.advance(INF)
		set_process_unhandled_input(false)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_options_menu"):
		if not ui_customize_character.visible:
			ui_customize_character.show()
		else:
			ui_customize_character.hide()
			_savegame.write_savegame()
		get_tree().paused = ui_customize_character.visible


func _process(delta: float) -> void:
	ui_remaining_time.text = get_remaining_time_text(false)


func start() -> void:
	set_process(true)
	for player in players:
		player.set_physics_process(true)
	timer.start()


func show_split_screen() -> void:
	split_viewports_container.show()
	viewport_overview_container.hide()
	

func finish_game(body: KinematicBody2D) -> void:
	animation_player.play("finish_game")
	ui_info.text = "You lost!"
	
	if timer.time_left > 0.0:
		var player_index := players.find(body) + 1
		ui_info.text = "Player %s won!" % [player_index]
	set_process(false)
	for player in players:
		player.set_physics_process(false)
	timer.stop()


func get_remaining_time_text(is_in_ready: bool) -> String:
	var time: float = timer.time_left
	if is_in_ready:
		time = timer.wait_time
	return str(time).pad_decimals(2)


# Creates a save file with the default configuration
func _create_savegame() -> void:
	_savegame = SaveGame.new()
	_savegame.player_1 = preload("player_1_settings.tres").duplicate()
	_savegame.player_2 = preload("player_2_settings.tres").duplicate()
	# We can instantly save the file to ensure we're always working with a
	# player-specific file from here on out.
	_savegame.write_savegame()


func _on_Finish_body_entered(body: Node) -> void:
	finish_game(body)
