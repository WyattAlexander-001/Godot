extends SpinBox

signal updated(value)
var _old_value: int


func _ready() -> void:
	# Making sure this isn't used in the wrong scene by doing a property check
	assert('skill_points' in owner, "Expected owner to have `skill_points` property")
	assert(owner.skill_points is int, "Expected owner's `skill_points` property to be an int")
	
	# We store the initial value for later
	_old_value = int(value)
	connect("value_changed", self, "_on_changed")


func _on_changed(_new_value: float) -> void:
	var diff := value - _old_value
	var updated_skill_points := int(owner.skill_points - diff)
	if updated_skill_points >= 0:
		_old_value = int(value)
		owner.skill_points = updated_skill_points
		emit_signal("updated", value)
	else:
		# there were not enough points, we restore the previous value
		value = float(_old_value)
