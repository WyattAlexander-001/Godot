extends Control

export var max_count := 3

onready var _label := $Label
onready var _animation_player := $AnimationPlayer


func _on_Timer_timeout() -> void:
	assert(_label.text.is_valid_integer())

	var counter := int(_label.text)
	counter = wrapi(counter + 1, 1, max_count + 1)
	_label.text = str(counter)

	_animation_player.play("grow_text")
