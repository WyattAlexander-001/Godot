extends Particles2D


func _ready() -> void:
	one_shot = true
	emitting = true
	var time = 2.0 * lifetime / speed_scale
	get_tree().create_timer(time).connect("timeout", self, "queue_free")
