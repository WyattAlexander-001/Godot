extends PracticeTests

var counter := 0
var ui_counter_text := ""
var gems_changed_in_parent_scene := false

var gem: Area2D = preload("Gem.tscn").instance()

onready var godot := scene_root.get_node("Godot") as KinematicBody2D
onready var godot_area: Area2D = scene_root.get_node("Godot/Area2D")

func _init() -> void:
	add_requirement("Gems/Gem", [], ["_on_area_entered"])
	add_requirement("Godot")


func _prepare_async():
	._prepare_async()
	yield(get_tree().create_timer(0.5), "timeout")
	for scene_gem in scene_root.get_node("Gems").get_children():
		scene_gem = scene_gem as Area2D
		if scene_gem.collision_layer != gem.collision_layer:
			gems_changed_in_parent_scene = true


func test_godot_area_is_connected() -> String:
	var godot_area_is_connected = godot_area.is_connected("area_entered", scene_root, "_on_GodotArea2D_area_entered")
	if not godot_area_is_connected:
		return tr("godot's area is not connected to the root scene's _on_GodotArea2D_area_entered. Did you set up the signal correctly in _ready()?")
	return ""


func test_godot_area_has_exactly_one_mask() -> String:
	var count := _count_layers(godot_area.collision_mask)
	if count == 0:
		return tr("Godot's area has no collision mask set at all. Make sure to set the appropriate mask!")
	if count > 1:
		return tr("Godot's area has more than one collision mask set. Plase make sure you selected only one.")
	return ""


func test_godot_can_pick_gems() -> String:
	var matches_layers := godot_area.collision_layer & gem.collision_mask > 0
	var matches_mask := godot_area.collision_mask & gem.collision_layer > 0
	var matches :=  matches_mask || matches_layers
	if not matches:
		var wrong_matches_layers := godot.collision_layer & gem.collision_mask > 0
		var wrong_matches_mask := godot.collision_mask & gem.collision_layer > 0
		var wrong_matches :=  wrong_matches_mask || wrong_matches_layers
		if wrong_matches:
			return tr("You seem to have set the layers on the Godot node! Make sure you set the layer inside the Godot scene, on the Area2D node.")
		return tr("The gems' collision layer does not match any of the player's area masks. Did you set the Gem node's collision layer to match the player's area mask?")
	return ""



func _count_layers(selected: int) -> int:
	var count := 0
	for flag_num in 7:
		var bit = 1 << flag_num
		if selected & bit > 0:
			count += 1
	return count


func test_gem_has_exactly_one_layer() -> String:
	var count := _count_layers(gem.collision_layer)
	if  count > 1:
		return tr("You selected more layers than necessary. Please select only the appropriate collision layers.")
	if count == 0:
		return tr("The gem has no layer. Please select a collision layer.")
	return ""


func test_gem_not_changed_in_main_scene() -> String:
	if gems_changed_in_parent_scene:
		return tr("You have modified the collision layers in the main scene instead of inside the gem scene itself. Make sure you open the gem scene and change the layers there!")
	return ""


func test_picking_increases_the_counter() -> String:
	save_counter()
	var expected_counter = scene_root.counter + 1
	scene_root._on_GodotArea2D_area_entered(null)

	var msg := ""
	if not expected_counter == scene_root.counter:
		msg = tr("The counter isn't increasing properly. Did you forget to increment the counter before setting the label text?")

	reset_counter()
	return msg


func test_ui_counter_text_updates() -> String:
	save_counter()
	var expected_counter = scene_root.counter + 1
	scene_root._on_GodotArea2D_area_entered(null)
	
	var msg := ""
	
	if not expected_counter == scene_root.counter:
		msg = tr("the UI counter label does not update")
	else:
		var number := str(scene_root.counter)
		var expected_text := "Gems*:*" + number
		var current_text := (scene_root.ui_counter as Label).text.strip_edges()
		
		if not current_text.matchn(expected_text):
			if current_text.matchn("*%s"%[number]):
				msg = tr("The UI counter label updates, but you seem to have forgotten to write `Gems: ` before the number.")
			else:
				msg = tr("The UI counter label doesn't show the correct text. Did you forget to set the label's text value?")
	reset_counter()
	return msg


func save_counter() -> void:
	counter = scene_root.counter
	ui_counter_text = scene_root.ui_counter.text



func reset_counter() -> void:
	scene_root.counter = counter
	scene_root.ui_counter.text = ui_counter_text
