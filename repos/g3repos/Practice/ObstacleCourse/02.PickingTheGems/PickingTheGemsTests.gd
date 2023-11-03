extends PracticeTests

var GEM_SCENE := preload("Gem.tscn")
var gem: Area2D = GEM_SCENE.instance()
var wall: StaticBody2D = preload("BrokenWall.tscn").instance()
onready var player: KinematicBody2D = scene_root.get_node("Godot") as KinematicBody2D


var gem_is_connected := false
var gem_gets_freed := false


func _init() -> void:
	add_requirement("Gems/Gem", [], ["_on_body_entered"])
	add_requirement("Godot")


func _prepare_async():
	._prepare_async()
	
	var _gem: Area2D = GEM_SCENE.instance()
	_gem.hide()
	add_child(_gem)

	gem_is_connected = _gem.is_connected("body_entered", _gem, "_on_body_entered")
	_gem._on_body_entered(null)
	gem_gets_freed = _gem.is_queued_for_deletion()

	yield(get_tree().create_timer(0.5), "timeout")


func _count_layers(selected: int) -> int:
	var count := 0
	for flag_num in 7:
		var bit = 1 << flag_num
		if selected & bit > 0:
			count += 1
	return count


func test_only_one_layer_is_selected() -> String:
	var player_mask_count := _count_layers(player.collision_mask)
	var player_layer_count := _count_layers(player.collision_layer)
	var gem_mask_count := _count_layers(gem.collision_mask)
	var gem_layer_count := _count_layers(gem.collision_layer)
	
	print(player_layer_count)
	
	var both_masks_and_layer_message := tr("You have both masks and layers for your %s. You should only have one of those selected")
	var too_many_layers_message := tr("You have selected several %s %s. Make sure to pick only one.")
	
	if player_mask_count > 0 && player_layer_count > 0:
		return both_masks_and_layer_message%["player node"]
	if gem_mask_count > 0 && gem_layer_count > 0:
		return both_masks_and_layer_message%["gem node"]
	
	if player_mask_count > 1:
		return too_many_layers_message%["player", "masks"]
	if player_layer_count > 1:
		return too_many_layers_message%["player", "layers"]
	
	if gem_mask_count > 1:
		return too_many_layers_message%["gem", "masks"]
	if gem_layer_count > 1:
		return too_many_layers_message%["gem", "layers"]
	
	return ""

func test_godot_can_pick_gems() -> String:
	var matches_mask := gem.collision_layer & player.collision_mask > 0
	var matches_layer := gem.collision_mask & player.collision_layer > 0
	if not (matches_mask || matches_layer):
		return tr("The gem's collision mask does not match any of the player's physics layers. Did you set the Gem node's collision mask to match the player's layer?")
	return ""


func test_godot_is_blocked_by_walls() -> String:
	var matches_mask := wall.collision_layer & player.collision_mask > 0
	var matches_layer := wall.collision_mask & player.collision_layer > 0
	if not (matches_mask || matches_layer):
		return tr("The wall's collision layer does not match any of the player's mask layers. Did you set the Players node's collision mask to match the wall's layer?")
	return ""


func test_picking_gems_frees_them() -> String:
	if not gem_is_connected:
		return tr("The gem's body_entered is not connected to _on_body_entered(). Did you connect the signal in the _ready() function?")

	if not gem_gets_freed:
		return tr("When the player touches a gem, the gem doesn't get deleted. Did you call queue_free() in the callback function?")

	return ""
