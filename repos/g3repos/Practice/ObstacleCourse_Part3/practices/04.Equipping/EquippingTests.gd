extends PracticeTests

const Inventory := preload("Inventory.gd")
const Character := preload("Character.gd")
var left_hand_weapon := false
var right_hand_weapon := false

func _init() -> void:
	add_requirement("UIInventory/HBoxContainer/VBoxContainer/Equipment/LeftHandSlot")
	add_requirement("UIInventory/HBoxContainer/CenterContainer/Control/Character")


func _prepare_async():
	yield(get_tree(), "idle_frame")
	code = _preprocess_code(Inventory)
	
	var inventory := Inventory.new()
	var item_right := preload("../03.Saving/items/Boomerang.tres").duplicate()
	var item_left := preload("../03.Saving/items/Sword.tres").duplicate()
	inventory.connect("left_hand_changed", self, "_on_left_hand_changed", [inventory, item_left])
	inventory.connect("right_hand_changed", self, "_on_right_hand_changed", [inventory, item_right])
	inventory.set_left_hand_weapon(item_left)
	inventory.set_right_hand_weapon(item_right)
	
	yield(get_tree().create_timer(0.5), "timeout")


func _on_left_hand_changed(inventory: Inventory, item) -> void:
	left_hand_weapon = inventory.left_hand_weapon == item


func _on_right_hand_changed(inventory: Inventory, item) -> void:
	right_hand_weapon = inventory.right_hand_weapon == item



func test_left_hand_signal_is_emitted() -> String:
	if left_hand_weapon:
		return ""
	return tr("It seems no signal is emitted when we change the left hand weapon. Did you call `emit_signal` with the right signal name?")


func test_right_hand_signal_is_emitted() -> String:
	if right_hand_weapon:
		return ""
	return tr("It seems no signal is emitted when we change the right hand weapon. Did you call `emit_signal` with the right signal name?")


func test_left_hand_signal_is_connected() -> String:
	var character := scene_root.find_node("Character") as Character
	var inventory := character.inventory
	if inventory.is_connected("left_hand_changed", character, "_on_Inventory_left_hand_changed"):
		return ""
	return tr("When we change the left weapon, the character doesn't seem to know. Did you connect the correct signal to the correct function?")


func test_right_hand_signal_is_connected() -> String:
	var character := scene_root.find_node("Character") as Character
	var inventory := character.inventory
	if inventory.is_connected("right_hand_changed", character, "_on_Inventory_right_hand_changed"):
		return ""
	return tr("When we change the right weapon, the character doesn't seem to know. Did you connect the correct signal to the correct function?")
