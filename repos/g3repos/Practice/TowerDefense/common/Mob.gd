extends KinematicBody2D

# `reached_end` is called when the mob reaches the last target point
signal reached_end

# decides how fast a mob walks
export var speed := 100.0


onready var sprite := $Sprite as Sprite
onready var animation_player := $AnimationPlayer as AnimationPlayer
onready var progress_bar := $ProgressBar as ProgressBar

var points := PoolVector2Array()
var point_index := 0
var target := Vector2()
var velocity := Vector2.ZERO
var health := 100.0
var friends_in_front := []

func _ready() -> void:
	# we verify there are at least 2 points
	if points.size() < 2:
		push_error("Points are not specified; Mob requires points amount to be more than 1")
		return
	# pick the first point as the current target
	target = points[0]
	# move the mob directly there
	global_position = target


func _physics_process(_delta: float) -> void:
	if not points:
		# If we have no points, do nothing and exit early
		return
	if friends_in_front:
		# If there are friends ahead, wait for them to leave
		return
	if global_position.distance_to(target) < 10:
		# If we're close to the target
		# increment the points index by one so we pick the next point
		point_index += 1
		# if the index is equal to size, it is invalid
		# that means we have reached the last point. All that's left to do
		# is emit the signal and remove ourselves
		if point_index == points.size():
			emit_signal("reached_end")
			queue_free()
			return
		# if the index is still valid, use it to select the next target
		target = points[point_index]

	# Turn towards the target
	sprite.look_at(target)
	# Get the vector towards the target
	velocity = (target - global_position).normalized() * speed
	# Move the velocity
	velocity = move_and_slide(velocity)

# Take Damage is called by a missile that registers the mob in its area
func take_damage(amount: float) -> void:
	
	# Play the damage animation
	animation_player.play("take_damage")
	
	# we remove some health
	health -= amount
	progress_bar.value = health

	# we pop a number that shows the damage amount
	var damage_indicator := preload("../common/DamageIndicator.tscn").instance()
	get_tree().root.add_child(damage_indicator)
	damage_indicator.set_amount(amount)
	damage_indicator.global_position = global_position

	# if the mob lost all their health
	if health <= 0:
		health = 0
		# pop an explosion animation and remove the mob itself
		var explosion := preload("../common/AnimatedExplosion.tscn").instance()
		get_tree().root.add_child(explosion)
		explosion.global_position = global_position
		explosion.playing = true
		queue_free()
