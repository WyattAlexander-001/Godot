extends Area2D

var speed := 1200.0
var direction := Vector2.ZERO

onready var visibility_notifier := $VisibilityNotifier2D


func _ready() -> void:
	set_as_toplevel(true)
	visibility_notifier.connect("screen_exited", self, "queue_free")


func _physics_process(delta: float) -> void:
	position += speed * direction * delta


func setup(shoot_direction: Vector2, global_start_position: Vector2) -> void:
	direction = shoot_direction
	rotation = direction.angle()
