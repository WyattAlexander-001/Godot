extends Control

# a selection of Douglas Adams quotes
var sentences := [
	"Time is an illusion, lunchtime doubly so.",
	"Nothing travels faster than the speed of light, with the possible exception of bad news, which obeys its own special laws.",
	"Would it save you a lot of time if I just gave up and went mad now?",
	"My doctor says that I have a malformed public-duty gland and a natural deficiency in moral fibre and that I am therefore excused from saving universes.",
	"We demand rigidly defined areas of doubt and uncertainty!",
	"Don't Panic.",
	"The ships hung in the sky in much the same way that bricks don't.",
	"For a moment, nothing happened. Then, after a second or so, nothing continued to happen.",
]

var write_speed := 33.0

onready var _label := $NinePatchRect/Label
onready var _tween := $Tween


func _on_TextButton_pressed() -> void:
	sentences.shuffle()
	_label.text = sentences.front()
	_tween.interpolate_property(_label, "percent_visible", 0.0, 1.0, len(_label.text) / write_speed)
	_tween.start()
