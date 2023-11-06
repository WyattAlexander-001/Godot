extends Spatial

export var target_path: NodePath

onready var _target = get_node(target_path)
onready var _animator: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	_target.connect("is_visible", self, "_on_VisibilityNotifier_camera_entered")


func _on_VisibilityNotifier_camera_entered(is_visible: bool) -> void:
	_animator.play_backwards("FadeIn") if is_visible else _animator.play("FadeIn")


func _process(_delta: float) -> void:
	look_at(_target.transform.origin, Vector3.UP)
