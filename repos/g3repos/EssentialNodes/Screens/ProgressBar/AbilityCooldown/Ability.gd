extends TextureProgress

export var time_to_recharge: float = 3.0
# A shortcut lets us easily customize the input event that triggers the animation.
export var action_to_activate: ShortCut
# We use Tween to refill the bar's value over several seconds.
onready var _tween: Tween = $Tween
# We use AnimationPlayer to change the bar's tint colors, just for visual flair.
onready var _anim_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	value = max_value

func _unhandled_input(event: InputEvent) -> void:
	if action_to_activate.is_shortcut(event):
		if value == max_value:
			use_ability()

## Use tweens to set TextureProgress value to  minimum, restore it to maximum, and add color effects.
func use_ability() -> void:
	# time_to_recharge determines how long it takes to recharge the ability.
	_tween.interpolate_property(
		self, "value", min_value, max_value, time_to_recharge
	)
	_anim_player.play("use")
	_tween.start()
	# Wait for the TextureProgress value to reach its maximum:
	yield(_tween, "tween_all_completed")
	_anim_player.play("ready")

# Initialize each time it re-enters the tree.
func _enter_tree() -> void:
	value = max_value
	
	if _anim_player:
		_anim_player.play("ready")
	
	if _tween:
		_tween.remove_all()
