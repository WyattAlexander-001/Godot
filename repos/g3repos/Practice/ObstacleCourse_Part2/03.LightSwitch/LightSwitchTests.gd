extends PracticeTests

const LightScene: PackedScene = preload("Light.tscn")

var switch_is_connected := false


func _init() -> void:
	add_requirement("Godot")
	add_requirement("Switch", [], ["_on_body_entered"])


func _prepare_async():
	._prepare_async()

	yield(get_tree().create_timer(0.5), "timeout")

	var switch: Area2D = scene_root.get_node("Switch")
	switch_is_connected = switch.is_connected("body_entered", switch, "_on_body_entered")

# We do not use requirements so we can provide comprehensive error reporting to
# the student
func test_added_light_to_scene() -> String:
	var light = scene_root.switch.light
	if not light:
		for child in scene_root.switch.get_children():
			if child is Light2D:
				return tr("Switch has a Light2D child, but it isn't named 'Light'. Please make sure the node is named correctly.")
		for child in scene_root.get_children():
			if child is Light2D:
				return tr("It seems you added the Light to the root. Make sure it's a child of the Switch node!")
		return tr("Switch has no Light2D child. Are you sure you added the light at the correct place in the tree?")
	if not (light is Light2D):
		return tr("Switch has a child named Light, but it's not a Light2D. Did you add the right scene?")
	if not ((light as Light2D).filename == LightScene.resource_path):
		return tr("Switch has a child named Light, but it's not the right scene. Did you use the %s scene?")%[LightScene.resource_path]
	return ""


func test_godot_can_turn_on_the_lights() -> String:
	if not switch_is_connected:
		return tr("Switch's body_entered signal isn't connected to the proper function. Did you declare the connection in the _ready() function?")
	return ""


func test_switch_on_the_lights() -> String:
	if not scene_root.switch.light:
		return "We tried turning on the lights, but there is no light to turn on. Did you add the correct scene?"
	
	scene_root.switch._on_body_entered(null)

	var msg := ""
	if not scene_root.switch.light.enabled:
		msg = tr("The light can't be switched on even though we call the _on_body_entered() function. Did you forget to enable the light?")

	return msg


func test_start_the_switch_timer() -> String:
	scene_root.switch._on_body_entered(null)

	var msg := ""
	if scene_root.switch.timer.is_stopped():
		msg = tr("Did you forget to start the switch timer?")

	restore_state()
	return msg


func restore_state() -> void:
	scene_root.switch.timer.stop()
	scene_root.switch.animation_player.stop(true)
	scene_root.switch.animation_player.clear_queue()
	scene_root.switch.animation_player.play("RESET")
	if not scene_root.switch.light:
		return
	scene_root.switch.light.enabled = false
