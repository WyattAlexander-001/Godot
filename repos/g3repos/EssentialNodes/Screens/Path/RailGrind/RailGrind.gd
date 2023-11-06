extends Spatial

const Obstacle := preload("Obstacle.tscn")

const SCORE := "Touched: %d"
# We change the obstacle color when the player touches it for visual feedback.
const COLORS := {"default": Color("4da6ff"), "touch": Color("eb564b")}
# We generate a number of obstacles between `[OBSTACLES.min, OBSTACLES.max]` per path.
const OBSTACLES := {"min": 5, "max": 11}
const JUMP := {"height": 1, "time": 0.3}
const SPEED := 8

var _rng := RandomNumberGenerator.new()
var _score := 0 setget _set_score

onready var _path_follow: PathFollow = $Path/PathFollow
onready var _player_group: Spatial = $Path/PathFollow/PlayerGroup
onready var _player: Area = $Path/PathFollow/PlayerGroup/Player
onready var _tween: Tween = $Tween
onready var _obstacles: Spatial = $Obstacles
onready var _animation_player: AnimationPlayer = $AnimationPlayer
onready var _label_score: Label = $LabelScore


func _ready() -> void:
	_rng.randomize()
	_player.connect("area_entered", self, "_on_Player_area_entered_exited", [true])
	_player.connect("area_exited", self, "_on_Player_area_entered_exited", [false])

	# Generate obstacles on paths.
	for r in _rng_blue_noise(_rng.randi_range(OBSTACLES.min, OBSTACLES.max)):
		_path_follow.unit_offset = r
		var obstacle: Area = Obstacle.instance()
		obstacle.transform = _path_follow.transform
		_obstacles.add_child(obstacle)

	# After placing the obstacles, reset the `PathFollow` offset position.
	_path_follow.unit_offset = 0.0

	_set_score(0)
	set_physics_process(false)
	yield(get_tree().create_timer(0.5), "timeout")
	set_physics_process(true)

func _on_Player_area_entered_exited(area: Area, has_entered: bool) -> void:
	var material: Material = area.mesh_instance.get_active_material(0)
	if has_entered:
		material.albedo_color = COLORS.touch
		_set_score(_score + 1)
	else:
		material.albedo_color = COLORS.default


func _input(event: InputEvent) -> void:
	if not _tween.is_active() and event.is_action_pressed("jump_3d"):
		_tween.interpolate_property(
			_player, "translation:y", 0, JUMP.height, JUMP.time,Tween.TRANS_QUAD, Tween.EASE_OUT
		)
		_tween.interpolate_property(
			_player, "translation:y", JUMP.height, 0, JUMP.time, Tween.TRANS_QUAD, Tween.EASE_IN,
			JUMP.time
		)
		_tween.start()


func _physics_process(delta: float) -> void:
	_path_follow.offset += SPEED * delta
	if _path_follow.unit_offset >= 1.0:
		set_physics_process(false)


## Returns an array of the given size with random numbers between `(0, 1)` that have at least
## `padding` distance between them.
func _rng_blue_noise(size: int, padding: float = 0.01) -> Array:
	var out := []
	var cell := 1.0 / size
	for i in range(size):
		var x := padding + cell * i
		out.push_back(_rng.randf_range(x, x + cell - padding))
	return out


func _set_score(value: int) -> void:
	_score = value
	_label_score.text = SCORE % _score
