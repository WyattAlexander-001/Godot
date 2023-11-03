extends AnimatedSprite


func _ready() -> void:
	connect("animation_finished", self, "queue_free")
