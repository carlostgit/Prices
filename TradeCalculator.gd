extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const SatisfactionCalculator = preload("res://SatisfactionCalculator.gd")

var _satisfaction_calculator:SatisfactionCalculator = null

# Called when the node enters the scene tree for the first time.
func _ready():
#	testeo de calculate_combination_difference
	_satisfaction_calculator = SatisfactionCalculator.new()
	
	
	var combination_1:Dictionary = {"chocolate": 0, "candy": 0}
	var combination_2:Dictionary = {"chocolate": 2, "candy": 1}
	var combination_result = calculate_combination_difference(combination_1,combination_2)
	print (combination_result)
	
	
	print("best combi: "+ str(calculate_best_combination(50.0)))
	
	var bad_combi_too_much_candy:Dictionary = {"chocolate": 2, "candy": 50}
	var trade_result_too_much_candy:Dictionary = calculate_trade(bad_combi_too_much_candy)
	print("Too much candy result:")
	print (trade_result_too_much_candy)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _init(satisf_calc_arg:SatisfactionCalculator=null):
	_satisfaction_calculator=satisf_calc_arg

func calculate_trade(combination_dict_arg:Dictionary)->Dictionary:
	
	var satisfaction:float =_satisfaction_calculator.calculate_satisf(combination_dict_arg)
	#Prices está en autoload, por lo que lo puedo usar en cualquier lado
	var price:float = Prices.calculate_price(combination_dict_arg)
		
	var best_combination:Dictionary = calculate_best_combination(price)
	var satisfaction_of_best_combination:float = _satisfaction_calculator.calculate_satisf(best_combination)
	
	var combination_diff:Dictionary = {}
	if (satisfaction_of_best_combination > satisfaction):
		combination_diff = calculate_combination_difference(best_combination,combination_dict_arg)

	return combination_diff

func calculate_best_combination(money_arg:float)->Dictionary:
#	var best_combination:Dictionary = {}
	var step_length:float = 1.0
	
	var products:Array = Prices.get_products()
	var combination:Dictionary = {}
	for product in products:
		combination[product] = 0
	
	var left_money:float = money_arg
	
#	var best_next_combination:Dictionary = combination.duplicate()
	while true:
#		print ("left money: "+ str(left_money))	
		var no_more_money = true
		var best_product_combination:Dictionary = {}
		var best_product_satisfaction = 0.0
		var best_product_price = 0.0
		for product in products:
			var trying_combination:Dictionary = combination.duplicate()
			trying_combination[product] += step_length
			var satisfaction_of_trying_combination = _satisfaction_calculator.calculate_satisf(trying_combination)
			var price = Prices.get_price_of_product(product)*step_length
			
			
			
			if price<left_money:
				no_more_money = false
				
				var satisfacton_of_trying_combination_for_price = satisfaction_of_trying_combination/price
				
#				print("product: "+ product)
#				print(trying_combination)
#				print ("satisf for price: " + str(satisfacton_of_trying_combination_for_price))
				
				if satisfacton_of_trying_combination_for_price > best_product_satisfaction:
					best_product_satisfaction = satisfacton_of_trying_combination_for_price
					best_product_combination = trying_combination
					best_product_price = price
		
		if no_more_money:
			break
		else:
			left_money -= best_product_price
			combination = best_product_combination
			
		
	
	return combination
	
	
func calculate_combination_difference(combination_1_arg:Dictionary, combination_2_arg:Dictionary)->Dictionary:
	#1-2
	var return_dict:Dictionary = combination_1_arg.duplicate()
	for product_2 in combination_2_arg.keys():
		if return_dict.has(product_2):
			return_dict[product_2] = return_dict[product_2] - combination_2_arg[product_2]
		else:
			return_dict[product_2] =  - combination_2_arg[product_2]

	return return_dict
