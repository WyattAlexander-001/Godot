extends Control

# We create a constant to define the ShopItem type only in this script.
const ShopItem := preload("ShopItem.gd")

export var shop_item_scene: PackedScene

var player_cash := 451

onready var _item_grid: GridContainer = $NinePatchRect/VBoxContainer/GridContainer
onready var _money_label: Label = $NinePatchRect/VBoxContainer/HBoxContainer/MoneyLabel

var items := {
	"Rocket Fuel": {"cost": 15, "amount": 4},
	"O2 Canisters": {"cost": 11, "amount": 2},
	"Ion Battery": {"cost": 14, "amount": 6},
	"Rocket": {"cost": 25, "amount": 4},
	"MKIII Cannon": {"cost": 300, "amount": 1},
	"MKII Cannon": {"cost": 200, "amount": 1},
	"MKI Cannon": {"cost": 100, "amount": 1},
	"Repair supplies": {"cost": 8, "amount": 5},
}


func _ready() -> void:
	update_money_label()
	populate_shop()


func populate_shop() -> void:
	for item_name in items:
		var shop_item := shop_item_scene.instance()
		var item_data: Dictionary = items[item_name]
		shop_item.setup(item_name, item_data.cost, item_data.amount)
		_item_grid.add_child(shop_item)
		shop_item.connect("pressed", self, "purchase", [shop_item])


func update_money_label() -> void:
	_money_label.text = "your money: $%d" % player_cash


func purchase(item: ShopItem) -> void:
	if player_cash >= item.cost:
		player_cash -= item.cost
		update_money_label()
		item.buy()
