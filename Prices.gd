extends Control

const Combination = preload("res://Combination.gd")

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

func set_price_of_product(product_arg:String, price_arg:float)->void:
	if _products.has(product_arg):
		_prices_dict[product_arg]=price_arg

func get_price_of_product(product_arg:String)->float:
	if _products.has(product_arg):
		return _prices_dict[product_arg]
	else:
		return 0.0

func calculate_combination_price(combination_arg:Combination)->float:
	return calculate_combidict_price(combination_arg.get_combidict())

func calculate_combidict_price(combidict_arg:Dictionary)->float:

	var total_price:float = 0.0
	for product in combidict_arg.keys():
		if _prices_dict.has(product):
			total_price += _prices_dict[product]*combidict_arg[product]

	var price_of_currency:float = _prices_dict[_currency]
	
	var total_price_for_currency = total_price/price_of_currency
	
	return total_price_for_currency

func get_products()->Array:
	return _products

func get_combidict()->Dictionary:
	return _prices_dict
