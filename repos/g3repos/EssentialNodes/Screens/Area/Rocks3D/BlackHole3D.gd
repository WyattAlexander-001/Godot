extends Area

func activate() -> void:
	if space_override == Area.SPACE_OVERRIDE_DISABLED:
		space_override = Area.SPACE_OVERRIDE_REPLACE
	else:
		space_override = Area.SPACE_OVERRIDE_DISABLED
