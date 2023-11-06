extends Button

var cost := 0
var quantity := 1


func setup(name_in: String, cost_in: int, quantity_in: int) -> void:
	name = name_in
	cost = cost_in
	quantity = quantity_in
	update_text()


func buy() -> void:
	quantity -= 1
	disabled = quantity < 1
	update_text()


func update_text() -> void:
	text = "%s - $%d (%d)" % [name, cost, quantity]
