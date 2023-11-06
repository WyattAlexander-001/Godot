extends KinematicBody2D

onready var _sprite := $Sprite
onready var target: Node2D = $"../Player"
onready var animation_player := $AnimationPlayer

var speed := 400.0
var steer_force := 10.0
var velocity := Vector2.ZERO
var acceleration := Vector2.ZERO


func _ready() -> void:
	rotation += rand_range(0, 6.2)
	velocity = position.rotated(rotation) * speed


func get_steering() -> Vector2:
	var steer := Vector2.ZERO
	var target_steer: Vector2 = (target.position - position).normalized() * speed
	steer = (target_steer - velocity).normalized() * steer_force
	return steer


func _physics_process(delta: float) -> void:
	acceleration += get_steering()
	velocity += acceleration * delta
	velocity = velocity.clamped(speed)
	rotation = velocity.angle() + PI / 2
	velocity = move_and_slide(velocity)


func _on_HitBox_body_entered(body: PhysicsBody2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage()


func take_damage() -> void:
	animation_player.play("Dead")


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "Dead":
		queue_free()
