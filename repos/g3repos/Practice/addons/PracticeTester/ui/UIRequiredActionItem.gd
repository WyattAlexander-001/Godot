extends CheckBox

var _action: String

func setup(required_action: String) -> void:
	_action = required_action
	text = _action

func matches_action(required_action: String) -> bool:
	return _action == required_action

func get_action() -> String:
	return _action
