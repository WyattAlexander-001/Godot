extends BaseEnemyAI

enum State { IDLE, FOLLOWING, CHARGING }

const CHARGE_DISTANCE := 400.0 * 400.0

var vision_range := 400.0

var _charge_direction := Vector2.ZERO
var _charge_speed := 800.0

var _charge_timer := Timer.new()
var _charge_duration := 0.5

var _cooldown_timer := Timer.new()
var _cooldown_duration := 2.0

var _wait_timer := Timer.new()
var _wait_duration := 0.8

var _state: int = State.IDLE
var _float_offset = rand_range(0.0, 5.0)

onready var _line_of_sight: RayCast2D = $LineOfSight
onready var _sprite: Sprite = $Sprite


func _ready() -> void:
	add_child(_charge_timer)
	_charge_timer.one_shot = true
	_charge_timer.wait_time = _charge_duration
	_charge_timer.connect("timeout", self, "set_state", [State.IDLE])

	add_child(_cooldown_timer)
	_cooldown_timer.one_shot = true
	_cooldown_timer.wait_time = _cooldown_duration

	add_child(_wait_timer)
	_wait_timer.one_shot = true
	_wait_timer.wait_time = _wait_duration


func _set_target(new_target: Player) -> void:
	._set_target(new_target)
	_line_of_sight.enabled = _target != null


func _physics_process(delta: float) -> void:
	if not _is_active:
		animate_floating()
		return
		
	_target = find_target()

	if _state == State.IDLE:
		if _target:
			set_state(State.FOLLOWING)
		animate_floating()

	elif _state == State.FOLLOWING:
		if not _target:
			set_state(State.IDLE)
			return

		follow(_target.global_position)
		_sprite.look_at(_target.global_position)
		_hit_box.look_at(_target.global_position)
		animate_floating()

		var distance_squared := global_position.distance_squared_to(_target.global_position)
		var direction := global_position.direction_to(_target.global_position)
		_line_of_sight.cast_to = direction * vision_range

		if not does_see_target():
			set_state(State.IDLE)
		elif distance_squared < CHARGE_DISTANCE and _cooldown_timer.is_stopped():
			set_state(State.CHARGING)

	elif _state == State.CHARGING:
		# Wait for a moment, then
		# Move in the direction of the target over 400 pixels
		if not _wait_timer.is_stopped():
			return
		elif _charge_timer.is_stopped():
			_charge_timer.start()

		_velocity = _charge_speed * _charge_direction
		move_and_slide(_velocity)


func set_state(new_state: int) -> void:
	if new_state == State.CHARGING:
		_wait_timer.start()
		_charge_direction = global_position.direction_to(_target.global_position)
		
		_sprite.texture = texture_active

	if new_state == State.IDLE:
		_sprite.texture = texture_inactive

	if _state == State.CHARGING:
		_cooldown_timer.start()
	
	_state = new_state


func does_see_target() -> bool:
	return _line_of_sight.is_colliding() and _line_of_sight.get_collider() == _target


func animate_floating() -> void:
	_sprite.position.y = sin(OS.get_ticks_msec() / 200.0 + _float_offset) * 8.0
