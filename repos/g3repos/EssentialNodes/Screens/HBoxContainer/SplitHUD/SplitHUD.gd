extends Control

var _score: int = 0 setget set_score

onready var _score_label: Label = $HBoxContainer/ScoreLabel
onready var _health_bar: ProgressBar = $HBoxContainer/HealthBar
onready var _tween: Tween = $HBoxContainer/Tween
onready var _button: Button = $PlayAnimations


func _ready() -> void:
	_button.connect("pressed", self, "_on_Button_pressed")


func set_score(score_in: int) -> void:
	_score = score_in
	_score_label.text = "%07d" % _score


func _on_Button_pressed() -> void:
	_button.disabled = true
	_tween.interpolate_property(
		_health_bar, "value", 0.0, 100.0, 2.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT
	)
	_tween.interpolate_property(
		_health_bar, "value", 100.0, 0.0, 2.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 2.5
	)
	_tween.interpolate_property(
		self, "_score", 0, 250000, 2.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT
	)
	_tween.interpolate_property(
		self, "_score", 250000, 0, 2.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 2.5
	)
	_tween.start()
	yield(_tween, "tween_all_completed")
	_button.disabled = false

