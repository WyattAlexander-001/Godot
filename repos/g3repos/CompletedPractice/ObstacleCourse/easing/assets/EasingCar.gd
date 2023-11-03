tool
extends Control


enum EaseType{
	EASE_IN,
	EASE_OUT,
	EASE_IN_OUT,
	EASE_OUT_IN,
	LINEAR
}


export(EaseType) var easing: int = EaseType.EASE_IN_OUT setget set_easing
export var car_side_margin := 80.0
export var car_animation_duration := 2.0


onready var _car := $Car as Sprite
onready var _label := $Label as Label

const DEFAULT_TRANSITION := Tween.TRANS_EXPO

var _tween: SceneTreeTween
var _transition := DEFAULT_TRANSITION
var _easing := Tween.EASE_IN_OUT
var _method_tweener: MethodTweener
var _method_tweener_back: MethodTweener


func _ready() -> void:
	_start_tweening()
	set_easing(easing)


func _start_tweening() -> void:
	if _tween:
		_tween.kill()
		_tween = null
	
	_tween = create_tween()
	_tween.set_trans(_transition)
	_tween.set_ease(_easing)
	_method_tweener = _tween.tween_method(self, "_animate", 0.0, 1.0, car_animation_duration, [ 1.0 ])
	_method_tweener_back = _tween.tween_method(self, "_animate", 1.0, 0.0, car_animation_duration, [ -1.0 ])
	_tween.set_loops()


# Tween callback, called on each frame
func _animate(value: float, car_scale: float) -> void:
	
	var height := rect_size.y / 2
	var start := Vector2(car_side_margin, height)
	var end := Vector2(rect_size.x - car_side_margin, height)
	
	_car.position = lerp(start, end, value) 
	_car.scale.x = car_scale


func set_easing(new_easing: int) -> void:
	easing = new_easing
	if easing == EaseType.LINEAR:
		_transition = Tween.TRANS_LINEAR
		_easing = Tween.EASE_IN_OUT
	else:
		_transition = DEFAULT_TRANSITION
		_easing = easing
	
	if not is_inside_tree():
		yield(self, "ready")
	
	_method_tweener.set_trans(_transition)
	_method_tweener_back.set_trans(_transition)
	_method_tweener.set_ease(_easing)
	_method_tweener_back.set_ease(_easing)
	
	var text: String = EaseType.keys()[easing]
	_label.text = text
