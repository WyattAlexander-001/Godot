extends Spatial

export var pellet_scene: PackedScene
export var max_ammo := 3

var _current_ammo := max_ammo

onready var _animator: AnimationPlayer = $AnimationPlayer


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot_3d"):
		shoot()

func shoot() -> void:
	if _animator.is_playing():
		return
	_animator.queue("Fire")
	if _current_ammo < 1:
		_animator.queue("Reload")
	_current_ammo = posmod(_current_ammo - 1, max_ammo)
	_animator.queue("Pump")
	for _index in 9:
		var pellet: RayCast = pellet_scene.instance()
		add_child(pellet)
