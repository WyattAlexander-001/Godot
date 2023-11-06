extends Spatial

const CARD_ROTATION := deg2rad(15.0)
const HAND_SPREAD := 5.0
const HEIGHT_DIFFERENCE := 0.02

export var height_curve: Curve
export var rotation_curve: Curve


func _ready() -> void:
	var adjusted_card_count := get_child_count() - 1.0

	for child_index in get_child_count():
		var child := get_child(child_index) as Card3D
		assert(child != null, "Hand expects Card3D children")
		var ratio_in_hand := float(child_index) / adjusted_card_count
		child.translation.z = (
			-(HAND_SPREAD * adjusted_card_count * 0.5)
			+ child_index * HAND_SPREAD
		)
		child.rotation.y += (
			rotation_curve.interpolate(ratio_in_hand)
			* CARD_ROTATION
		)
		child.translation.x += height_curve.interpolate(ratio_in_hand) * 2
		child.translation.y += child_index * HEIGHT_DIFFERENCE
