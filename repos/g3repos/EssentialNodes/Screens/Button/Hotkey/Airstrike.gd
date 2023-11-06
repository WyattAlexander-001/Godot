extends Area2D

## Path to a button to toggle the air strike mode.
export var button_path: NodePath

onready var _button: Button = get_node(button_path)
onready var _anim_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	# We have to wait for a common ancestor to the air strike and the button to
	# be ready to ensure the button is in the scene tree.
	yield(owner, "ready")
	_button.connect("toggled", self, "toggle_visibility")


func _process(_delta: float) -> void:
	if not _anim_player.is_playing():
		global_position = get_global_mouse_position()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("click") and can_strike():
		launch_air_strike()


func can_strike() -> bool:
	return visible and not _anim_player.is_playing()


func launch_air_strike() -> void:
	# We disable the button to prevent toggling the airstrike mode during an air
	# strike.
	_button.disabled = true

	for body in get_overlapping_bodies():
		if body.has_method("take_damage"):
			body.take_damage()

	_anim_player.play("explosion")
	yield(_anim_player, "animation_finished")
	_button.disabled = false
	_button.pressed = false


func toggle_visibility(visibility: bool) -> void:
	visible = visibility
