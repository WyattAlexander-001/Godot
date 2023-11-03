## Base class for enemies. Defines some functions you can reuse to create
## different kinds of enemies.
class_name BaseEnemyAI
extends KinematicBody2D

signal died

export (StreamTexture) var texture_active
export (StreamTexture) var texture_inactive

export var damage := 1
export var health := 2

var speed := 250.0
var orbit_angle_interval := deg2rad(10.0)

var _is_active := false

var _target: Player
var _velocity := Vector2.ZERO
var _drag_factor := 6.0

onready var _detection_area: Area2D = $DetectionArea
onready var _hit_box: Area2D = $HitBox
onready var _die_sound: AudioStreamPlayer2D = $DieSound


func _ready() -> void:
	assert(texture_active, "%s needs an active texture." % [name])
	assert(texture_inactive, "%s needs an inactive texture." % [name])
	_hit_box.connect("body_entered", self, "_on_HitBox_body_entered")


func activate() -> void:
	_is_active = true


# Steers towards the target position.
func follow(target_global_position: Vector2) -> void:
	var desired_velocity := global_position.direction_to(target_global_position) * speed
	var steering := desired_velocity - _velocity
	_velocity += steering / _drag_factor
	_velocity = move_and_slide(_velocity, Vector2.ZERO)


# Orbit around the target if there is one.
func orbit_target() -> void:
	var target_distance := 200.0
	var direction := _target.global_position.direction_to(global_position)
	var offset_from_target := direction.rotated(PI / 6.0) * target_distance
	follow(_target.global_position + offset_from_target)


func take_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		die()


func die() -> void:
	emit_signal("died")
	visible = false

	# We remove anything that can trigger collisions again and leave the monster
	# as an invisible wall.
	_hit_box.queue_free()
	collision_layer = 0
	collision_mask = 0
	set_physics_process(false)
	
	_die_sound.pitch_scale = rand_range(0.95, 1.05)
	_die_sound.play()
	yield(_die_sound, "finished")
	queue_free()


func find_target() -> Player:
	var overlapping_bodies := _detection_area.get_overlapping_bodies()
	if not overlapping_bodies.empty():
		return overlapping_bodies.front()
	return null


func _on_HitBox_body_entered(body: Node) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage)
