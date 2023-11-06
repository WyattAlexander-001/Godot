extends Spatial

onready var _spring: Spatial = $Spring
onready var _ball: RigidBody = $Ball
onready var _launch_button: StaticBody = $Panel/PanelButton
onready var _slider: HSlider = $CanvasLayer/HSlider


func _ready() -> void:
	_launch_button.connect("pressed", self, "launch_object")
	_ball.connect("body_entered", self, "_on_Ball_body_entered")


func launch_object() -> void:
	_ball.apply_central_impulse(Vector3(0, _slider.value * 10, 0))
	_spring.bounce(_slider.value)


func _on_Ball_body_entered(_body) -> void:
	_launch_button.reset()
