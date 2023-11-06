extends RigidBody

export var shattered_crate_scene: PackedScene
export var highlight_material: ShaderMaterial

onready var _crate_material0: Material = $CrateGreen/crate_green.get_active_material(0)
onready var _crate_material1: Material = $CrateGreen/crate_green.get_active_material(1)
onready var _animation_player: AnimationPlayer = $AnimationPlayer


func highlight() -> void:
	_animation_player.play("highlight")
	_animation_player.seek(0.0, true)

func shatter() -> void:
	var shattered_crate: Spatial = shattered_crate_scene.instance()
	get_parent().add_child(shattered_crate)
	shattered_crate.global_transform = global_transform
	queue_free()

func enable_material_highlight(is_enabled: bool) -> void:
	_crate_material0.next_pass = highlight_material if is_enabled else null
	_crate_material1.next_pass = highlight_material if is_enabled else null
