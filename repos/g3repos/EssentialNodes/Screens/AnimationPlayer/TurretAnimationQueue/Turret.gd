extends Node2D

const ATTACK_PATTERN_REPETITIONS := {"cooldown": 2, "burst": 3, "spray": 1}

export var player_path: NodePath

onready var _shoot_animator := $Pivot/Gun/AnimationShoot
onready var _pattern_animator := $Pivot/AnimationPattern
onready var _bullet_launcher := $Pivot/Gun/BulletLauncher

onready var _player: Player = get_node_or_null(player_path)


func _ready() -> void:
	randomize()
	_pattern_animator.connect("animation_finished", self, "_on_AnimationPattern_animation_finished")
	queue_shooting_pattern()


func _process(_delta: float) -> void:
	if not _player:
		return
	look_at(_player.global_position)


func queue_shooting_pattern() -> void:
	# Get the attack animation names from the dictionary.
	var animations: Array = ATTACK_PATTERN_REPETITIONS.keys()
	# Randomize the order of our list of attacks, so the item at the front will
	# be random.
	animations.shuffle()
	var first_key: String = animations.front()

	# Find out how many times our animation should repeat
	for _x in range(ATTACK_PATTERN_REPETITIONS[first_key]):
		# Queue the animation so it will repeat for each time it's called in the
		# loop.
		_pattern_animator.queue(first_key)


func shoot() -> void:
	_bullet_launcher.fire()
	_shoot_animator.stop()
	_shoot_animator.play("shoot")


# We need this callback because the signal comes with an argument but our
# queue_shooting_pattern() function takes none.
func _on_AnimationPattern_animation_finished(_anim_name: String) -> void:
	queue_shooting_pattern()
