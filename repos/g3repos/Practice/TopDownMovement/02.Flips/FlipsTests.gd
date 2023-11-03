extends PracticeTests

onready var sprite: Sprite = scene_root.get_node("Godot/Sprite")
onready var checkbox_h: CheckButton = scene_root.get_node("CanvasLayer/VBoxContainer/CheckButtonFlipH")
onready var checkbox_v: CheckButton = scene_root.get_node("CanvasLayer/VBoxContainer/CheckButtonFlipV")
onready var slider: Slider = scene_root.get_node("CanvasLayer/VBoxContainer/HSlider")

func _prepare_async():
	._prepare_async()
	yield(get_tree().create_timer(0.5), "timeout")


func _init() -> void:
	add_requirement(".", [], ["_on_HSlider_value_changed", "_on_CheckButtonFlipH_toggled", "_on_CheckButtonFlipV_toggled"])
	add_requirement("Godot/Sprite")
	add_requirement("CanvasLayer/VBoxContainer/Label")
	add_requirement("CanvasLayer/VBoxContainer/HSlider", [], [], ["value_changed"])
	add_requirement("CanvasLayer/VBoxContainer/CheckButtonFlipH", [], [], ["toggled"])
	add_requirement("CanvasLayer/VBoxContainer/CheckButtonFlipV", [], [], ["toggled"])


func test_flipping_h_works() -> String:
	slider.value = 1
	if sprite.flip_h:
		return tr("The sprite started flipped horizontally, but it should not have. Please turn off its Flip H in the Inspector.")
	for switch in [true, false]:
		checkbox_h.pressed = switch
		if sprite.flip_h != checkbox_h.pressed:
			checkbox_h.pressed = false
			return tr("When toggling the CheckButtonFlipH button, the sprite does not flip horizontally accordingly. Did you set the sprite's flip_h property based on the toggled value in _on_CheckButtonFlipH_toggled()?")
	checkbox_h.pressed = false
	return ""


func test_flipping_v_works() -> String:
	slider.value = 1
	if sprite.flip_v:
		return tr("The sprite started flipped vertically, but it should not have. Please turn off its Flip V in the Inspector.")
	for switch in [true, false]:
		checkbox_v.pressed = switch
		if sprite.flip_v != checkbox_v.pressed:
			checkbox_v.pressed = false
			return tr("When toggling the CheckButtonFlipV button, the sprite does not flip vertically accordingly. Did you set the sprite's flip_v property based on the toggled value in _on_CheckButtonFlipV_toggled()?")
	checkbox_v.pressed = false
	return ""
