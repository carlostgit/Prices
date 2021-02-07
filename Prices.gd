extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var _products = ["chocolate","candy"]
var _currency = "candy"
var _prices_dict = {"chocolate": 1.0, "candy":0.5}


# Called when the node enters the scene tree for the first time.
func _ready():
	
	for product in _products:
		print(product +": " + str(get_price_of_product(product)))
	
	var combination_dict:Dictionary = {"chocolate": 4,"candy":6}
#	print("combination price: "+str(calculate_price(combination_dict)))
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
		if _prices_dict.has(product):
			total_price += _prices_dict[product]*combination_dict_arg[product]
	return total_price

func get_products()->Array:
	return _products
