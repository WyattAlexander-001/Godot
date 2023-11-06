extends Control

var box_list := []

onready var _tween := $Tween


func _ready() -> void:
	for child in get_children():
		if child is TextureRect:
			box_list.append(child)
	assert(box_list)


func _enter_tree() -> void:
	for box in box_list:
		box.rect_scale = Vector2.ZERO
	
	if _tween:
		_tween.remove_all()

func animate_rectangles_appearing() -> void:
	# Reset the size of each rectangle
	for box in box_list:
		box.rect_scale = Vector2.ZERO
	
	for box in box_list:
		# We animate the rectangle's scale and rotation over one second, using the elastic easing equation.
		_tween.interpolate_property(
			box, "rect_scale", Vector2.ZERO, Vector2.ONE, 0.5, Tween.TRANS_ELASTIC, Tween.EASE_OUT
		)
		_tween.interpolate_property(
			box, "rect_rotation", -30, 0, 1.0, Tween.TRANS_ELASTIC, Tween.EASE_OUT
		)
		_tween.start()
		# We wait for the animation to complete before iterating the loop.
		yield(_tween, "tween_all_completed")


func _on_PopButton_pressed() -> void:
	if _tween.is_active():
		return

	animate_rectangles_appearing()
