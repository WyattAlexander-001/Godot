extends RigidBody2D

onready var _anim_player := $AnimationPlayer
onready var _pivot := $DustPivot
onready var _shape: Shape2D = $CollisionShape2D.shape


func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")


func _on_body_entered(body: Node) -> void:
	var motion_test_result := Physics2DTestMotionResult.new()

	test_motion(body.global_position, true, 0.08, motion_test_result)
	_pivot.rotation = motion_test_result.collider_velocity.angle()

	if body.has_method("get_hurt"):
		body.get_hurt(motion_test_result)
	if _anim_player.is_playing():
		return

	_anim_player.play("collide")
	yield(_anim_player, "animation_finished")
	_anim_player.play("disappear")
