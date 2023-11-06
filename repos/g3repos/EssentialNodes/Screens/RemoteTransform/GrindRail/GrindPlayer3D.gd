extends Player3D


func grind(is_grinding: bool) -> void:
	_model.jump() if is_grinding else _model.land()
