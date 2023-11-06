extends OptionButton

onready var _animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	self.connect("item_selected", self, "select_item")


func purchase() -> void:
	disabled = false
	_animation_player.play("bounce")


func select_item(index: int) -> void:
	_animation_player.play("bounce")


func is_available() -> bool:
	return disabled != false
