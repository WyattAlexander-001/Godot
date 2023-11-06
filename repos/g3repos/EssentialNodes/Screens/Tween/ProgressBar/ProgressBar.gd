extends Control

## This property keeps track of the current health, and its setter triggers the
## tween animation.
var health := 50 setget set_health

onready var _bar: TextureProgress = $Bar
onready var _tween: Tween = $Tween


func set_health(value: int) -> void:
	# We limit the `health` within the bar's value range.
	health = int(clamp(value, _bar.min_value, _bar.max_value))
	# Here, notice we call `interpolate_method()`. We have the `Tween` node
	# repeatedly call the `_update_health_bar()` method on this node.
	_tween.interpolate_method(self, "_update_health_bar", _bar.value, health, 0.33)
	_tween.start()


func _update_health_bar(health_target: float) -> void:
	_bar.value = health_target
	# We couldn't directly tween the color with `Tween.interpolate_property()`,
	# this is a case where we need to use `interpolate_method()` instead.
	_bar.tint_progress = Color("EB564B").linear_interpolate(
		Color("4DA6FF"), health_target / _bar.max_value
	)


func _ready() -> void:
	_update_health_bar(health)


func _on_HealButton_pressed() -> void:
	set_health(health + 10)


func _on_DamageButton_pressed() -> void:
	set_health(health - 10)
