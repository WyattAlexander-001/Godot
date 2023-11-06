extends Sprite

export var speed := 800.0
export var direction := Vector2.RIGHT

var _velocity := Vector2.ZERO

onready var _visibility_notifier: VisibilityNotifier2D = $VisibilityNotifier2D

func _ready() -> void:
	_visibility_notifier.connect("screen_exited", self, "queue_free")


func _physics_process(delta: float) -> void:
	rotation = direction.angle()
	_velocity = direction * speed
	translate(_velocity * delta)
