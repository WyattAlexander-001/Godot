extends PracticeTests

const ANIM_NAME = "blink"

onready var godot := scene_root.get_node("Godot") as KinematicBody2D
onready var button := scene_root.get_node("Godot") as Button
onready var animation_player := scene_root.get_node("AnimationPlayer") as AnimationPlayer


func _init() -> void:
	add_requirement("Godot")
	add_requirement("Button")
	add_requirement("AnimationPlayer")
	add_requirement(".", [], ["_on_button_toggled"])


func _prepare_async():
	._prepare_async()
	yield(get_tree().create_timer(0.5), "timeout")


func test_animation_exists() -> String:
	var list := animation_player.get_animation_list()
	if Array(list).find(ANIM_NAME) == -1:
		return tr("Did you create the '%s' animation? We found: %s")%[ ANIM_NAME, list.join(", ") if list.size() else "no animations"]
	return ""


func test_animation_loops() -> String:
	var anim := animation_player.get_animation(ANIM_NAME)
	if (not anim) or (not anim.loop):
		return tr("The '%s' animation does not loop. Are you sure you set the looping property correctly?")%[ANIM_NAME]
	return ""


func test_animation_player_handles_modulation() -> String:
	var anim := animation_player.get_animation(ANIM_NAME)
	var msg := tr("The '%s' animation doesn't seem to handle Godot's `modulate` property. Did you create the right track?")%[ANIM_NAME]
	if not anim:
		return msg
	var track_id := anim.find_track("Godot:modulate")
	if track_id == -1:
		track_id = anim.find_track("Godot:modulate:a")
		if track_id > -1:
			return tr("You created a Bezier animation track! Please create a property track for the exercise.")
	if track_id == -1:
		return msg
	return ""


func test_animation_player_keys_amount_is_correct() -> String:
	var anim := animation_player.get_animation(ANIM_NAME)
	var msg := tr("The '%s' animation requires at least 2 keys. Did you add keys?")%[ANIM_NAME]
	if not anim:
		return msg
	var track_id := anim.find_track("Godot:modulate")
	if track_id == -1:
		return msg
	var keys := anim.track_get_key_count(track_id)
	if keys < 2:
		return msg
	return ""


func test_animation_player_changes_modulate_property() -> String:
	var anim := animation_player.get_animation(ANIM_NAME)
	var msg := tr("The last key of the '%s' animation does not set modulate's alpha to 0.")%[ANIM_NAME]
	if not anim:
		return msg
	var track_id := anim.find_track("Godot:modulate")
	if track_id == -1:
		return msg
	var keys := anim.track_get_key_count(track_id)
	if keys < 2:
		return msg
	var value: Color = anim.track_get_key_value(track_id, keys - 1)
	if value.a != 0:
		return msg
	value = anim.track_get_key_value(track_id, 0)
	if value.a != 1:
		return tr("The first key does not set the alpha to 1")
	return ""

func test_button_triggers_animation() -> String:
	animation_player.stop()
	scene_root._on_button_toggled(true)
	if not animation_player.is_playing():
		return tr("Pressing the button did not activate the animation. Did you play the animation in `_on_button_toggled`?")
	if animation_player.current_animation != ANIM_NAME:
		return tr("Pressing the button played a different animation from '%s'. Did you specify the right animation?")%[ANIM_NAME]
	scene_root._on_button_toggled(false)
	if animation_player.is_playing():
		return tr("Untoggling the button did not stop the animation. Are you calling stop()?")
	return ""
