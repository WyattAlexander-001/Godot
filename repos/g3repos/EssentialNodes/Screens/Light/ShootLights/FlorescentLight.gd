extends StaticBody

export var light_color: Color = Color.white setget set_light_color

var _is_broken := false

onready var _animation_player: AnimationPlayer = $AnimationPlayer
onready var _collision_particles: Spatial = $CollisionParticles
onready var _light_meshes: Spatial = $LightMeshes
onready var _spot_light: SpotLight = $SpotLight


func _ready() -> void:
	randomize()
	_animation_player.seek(randf() * 2.0)
	_animation_player.play("idle")


func take_damage() -> void:
	if _is_broken:
		return

	_is_broken = true
	_animation_player.play("shot")
	for particles in _collision_particles.get_children():
		particles.emitting = true


func set_light_color(color: Color) -> void:
	light_color = color
	if not is_inside_tree():
		yield(self, "ready")

	_spot_light.light_color = color
	for light_mesh in _light_meshes.get_children():
		light_mesh.mesh.get("material").set("emission", color)
