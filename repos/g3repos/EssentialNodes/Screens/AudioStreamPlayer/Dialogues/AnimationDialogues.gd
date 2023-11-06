extends AnimationPlayer

var animations: Array = get_animation_list()


func play_next() -> void:
	if not animations.empty():
		play(animations.pop_front())


func skip() -> void:
	if is_playing():
		seek(current_animation_length, true)
	else:
		play_next()
