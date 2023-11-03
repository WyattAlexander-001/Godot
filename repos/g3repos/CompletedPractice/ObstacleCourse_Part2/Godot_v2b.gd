extends KinematicBody2D

const DIRECTION_TO_FRAME := {
	Vector2.DOWN: 0,
	Vector2.DOWN + Vector2.RIGHT: 1,
	Vector2.RIGHT: 2,
	Vector2.UP + Vector2.RIGHT: 3,
	Vector2.UP: 4,
}

const SPEED_SLOW := 100.0
const SPEED_DEFAULT := 700.0
const SPEED_FAST := 1100.0

# We update the speed variable to use our new constant.
var speed := SPEED_DEFAULT
var drag_factor := 0.13
var velocity := Vector2.ZERO

var start_collision_layer := collision_layer
var start_collision_mask := collision_mask

onready var sprite := $Sprite
onready var animation_player_ghost := $AnimationPlayerGhost
onready var timer_ghost := $TimerGhost
onready var slowdown_area := $Area2D
onready var smoke_particles := $SmokeParticles


func _ready() -> void:
	timer_ghost.connect("timeout", self, "toggle_ghost_effect", [false])
	slowdown_area.connect("area_entered", self, "_on_Area2D_area_entered")
	slowdown_area.connect("area_exited", self, "_on_Area2D_area_exited")


func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var desired_velocity := speed * direction
	var steering_vector := desired_velocity - velocity
	velocity += steering_vector * drag_factor
	move_and_slide(velocity)
	# The function is_equal_approx() safely tests the equality of two decimal
	# numbers.
	var is_speed_boost_active := is_equal_approx(speed, SPEED_FAST)
	var is_colliding := get_slide_count() > 0

	if is_speed_boost_active and is_colliding:
		speed = SPEED_DEFAULT

	var direction_to_frame_key := direction.round()
	direction_to_frame_key.x = abs(direction_to_frame_key.x)
	if direction_to_frame_key in DIRECTION_TO_FRAME:
		sprite.frame = DIRECTION_TO_FRAME[direction_to_frame_key]
		sprite.flip_h = sign(direction.x) == -1

	smoke_particles.emitting = velocity.length() > SPEED_DEFAULT / 2.0

func apply_speed_effect() -> void:
	speed = SPEED_FAST


func toggle_ghost_effect(is_on: bool) -> void:
	if is_on:
		timer_ghost.start()
		collision_layer = 0
		collision_mask = 0
		animation_player_ghost.play("ghost")
	else:
		collision_layer = start_collision_layer
		collision_mask = start_collision_mask
		animation_player_ghost.stop()


func _on_Area2D_area_entered(area: Area2D) -> void:
	# When entering or leaving the area, we ensure that it has the offcourse
	# node group to distinguish it from the push wall's area.
	if area.is_in_group("offcourse"):
		speed = SPEED_SLOW


func _on_Area2D_area_exited(area: Area2D) -> void:
	if area.is_in_group("offcourse"):
		speed = SPEED_DEFAULT
