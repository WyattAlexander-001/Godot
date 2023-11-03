extends Sprite

var bat_textures := [
	preload("res://SideScroller/08.HidingFromBatToy/bat_aware.png"),
	preload("res://SideScroller/08.HidingFromBatToy/bat_hang.png")
]

onready var raycast := $RayCast2D
onready var look_direction := $LookDirection


func _ready() -> void:
	raycast.cast_to = Vector2.ZERO


func _physics_process(delta: float) -> void:
	if not $Timer.is_stopped():
		return
	raycast.look_at(get_global_mouse_position())
	raycast.force_raycast_update()
	raycast.cast_to.x += 100 * delta

	if raycast.get_collider() is KinematicBody2D:
		texture = bat_textures[0]
	else:
		texture = bat_textures[1]
	
	if not raycast.get_collider():
		look_direction.vector = raycast.cast_to
		look_direction.look_at(get_global_mouse_position())
	else:
		look_direction.rotation = 0
		look_direction.vector = to_local(raycast.get_collision_point())
