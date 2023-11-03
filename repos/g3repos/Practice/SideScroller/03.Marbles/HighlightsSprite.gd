extends Sprite

onready var parent := get_parent()

func _ready() -> void:
	set_as_toplevel(true)
	

func _physics_process(delta: float) -> void:
	position = parent.global_position
