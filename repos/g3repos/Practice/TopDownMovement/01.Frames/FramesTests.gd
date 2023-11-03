extends PracticeTests


var sprite: Sprite
var slider: Slider


func _prepare_async():
	._prepare_async()
	yield(get_tree().create_timer(0.5), "timeout")
	sprite = scene_root.get_node("Godot/Sprite")
	slider = scene_root.get_node("CanvasLayer/VBoxContainer/HSlider")


func _init() -> void:
	add_requirement(".", [], ["_on_HSlider_value_changed"])
	add_requirement("Godot/Sprite")
	add_requirement("CanvasLayer/VBoxContainer/Label")
	add_requirement("CanvasLayer/VBoxContainer/HSlider", [], [], ["value_changed"])


func test_frame_does_change() -> String:

	var total_frames := sprite.hframes * sprite.vframes
	for frame in total_frames:
		slider.value = frame
		if sprite.frame != frame:
			slider.value = 0
			return tr("It seems the sprite's frame doesn't update when the slider's value changes. Did you change the sprite's frame property in _on_HSlider_value_changed()?")

	slider.value = 0
	return ""


func test_frame_matches_slider_value() -> String:
	var total_frames := sprite.hframes * sprite.vframes
	var index := total_frames - 1
	while index > 0:
		slider.value = index
		if sprite.frame != index:
			slider.value = 0
			return tr("The sprite's frame value doesn't match the slider's value. Did you use the value parameter in your function?")
		index -= 1
	slider.value = 0
	return ""
