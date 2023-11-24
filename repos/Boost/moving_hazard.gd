extends AnimatableBody3D

@export var destination: Vector3
@export var duration: float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	upDownMovingAbility()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func upDownMovingAbility():
	var tween = create_tween()
	tween.set_loops()
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "global_position", global_position + destination, duration) # move block up
	tween.tween_property(self, "global_position", global_position, duration)	
