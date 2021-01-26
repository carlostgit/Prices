extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var _products = ["chocolate","candy"]
var _currency = "candy"
var _prices_dict = {"chocolate": 2.0, "candy":1.0}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func get_price_of_product(product_arg:String)->float:
	if _products.has(product_arg):
		return _prices_dict[product_arg]
	else:
		return 0.0

func calculate_price(combination_dict_arg:Dictionary)->float:

	var total_price:float = 0.0
	for product in combination_dict_arg.keys():
		total_price += _prices_dict[product]
	return total_price


