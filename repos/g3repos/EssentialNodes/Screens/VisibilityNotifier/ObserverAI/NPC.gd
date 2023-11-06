extends Enemy3D

export var player_path: NodePath

onready var _visibility_notifier: VisibilityNotifier = $VisibilityNotifier
onready var _animator: AnimationPlayer = $Animator
onready var _player: FPSPlayer = get_node(player_path)


func _ready() -> void:
	_visibility_notifier.connect(
		"screen_entered", self, "_on_VisibilityNotifier_screen_entered", [true]
	)
	_visibility_notifier.connect(
		"screen_exited", self, "_on_VisibilityNotifier_screen_entered", [false]
	)
	set_physics_process(false)


func _on_VisibilityNotifier_screen_entered(is_visible: bool) -> void:
	if is_visible:
		_animator.play("NoticeLook")
	else:
		_animator.stop(true)
		set_physics_process(false)


func _physics_process(_delta: float) -> void:
	_model.look_at(_player.transform.origin, Vector3.UP)
