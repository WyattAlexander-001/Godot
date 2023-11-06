extends Spatial

var reset_delay := 0.3
var animation_time := 0.4
var reset_animation_time := 0.6

onready var _top: MeshInstance = $Top
onready var _body: Spatial = $Body
onready var _tween: Tween = $Tween


func bounce(strength: float) -> void:
	# We animate the top and reset its position after a delay
	_tween.interpolate_property(
		_top,
		"translation",
		_top.translation,
		Vector3(0, strength, 0),
		animation_time,
		Tween.TRANS_BOUNCE,
		Tween.EASE_OUT
	)
	_tween.interpolate_property(
		_top,
		"translation",
		Vector3(0, strength, 0),
		Vector3(0, 0.2, 0),
		reset_animation_time,
		Tween.TRANS_BACK,
		Tween.EASE_IN_OUT,
		# Notice we use the `delay` argument to play this animation after the
		# spring popped up.
		animation_time + reset_delay
	)
	# Animate the spring body and reset its scale after a delay
	_tween.interpolate_property(
		_body,
		"scale",
		_body.scale,
		Vector3(1, strength, 1),
		animation_time,
		Tween.TRANS_BOUNCE,
		Tween.EASE_OUT
	)
	_tween.interpolate_property(
		_body,
		"scale",
		Vector3(1, strength, 1),
		Vector3(1, 0.2, 1),
		reset_animation_time,
		Tween.TRANS_BACK,
		Tween.EASE_IN_OUT,
		animation_time + reset_delay
	)

	_tween.start()


func _ready() -> void:
	_body.scale = Vector3(1, 0.2, 1)
	_top.translation = Vector3(0, 0.2, 0)


func _enter_tree() -> void:
	if not _body:
		return

	_body.scale = Vector3(1, 0.2, 1)
	_top.translation = Vector3(0, 0.2, 0)
