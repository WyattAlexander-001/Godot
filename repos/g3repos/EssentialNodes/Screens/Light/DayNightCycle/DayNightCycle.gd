extends Spatial

const ROTATION_SPEED := deg2rad(15.0)

onready var _camera_pivot: Spatial = $CameraPivot

onready var _sky_shader: ShaderMaterial = $Viewport/SkyColor.material
onready var _environment: Environment = $WorldEnvironment.get_environment()
onready var _sun_light: DirectionalLight = $SunLight
onready var _sun_sprite: MeshInstance = $SunLight/Sun

onready var _animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	_animation_player.seek(3.0)


func _process(delta: float) -> void:
	_sun_sprite.get_active_material(0).albedo_color = _sun_light.get_color()

	var ambient_light_color: Color = _environment.get_ambient_light_color()
	_sky_shader.set_shader_param("sky_color", ambient_light_color.lightened(0.8))
	_sky_shader.set_shader_param("horizon_color", ambient_light_color)

	_camera_pivot.rotate_y(ROTATION_SPEED * delta)
