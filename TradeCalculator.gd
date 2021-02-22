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
	_satisfaction_calculator.init_default_satisfaction()
	
#	var combination_1:Dictionary = {"chocolate": 0, "candy": 0}
#	var combination_2:Dictionary = {"chocolate": 2, "candy": 1}
#	var combination_result = calculate_combination_difference(combination_1,combination_2)
#	print ("diff: "+ str(combination_result))
	
	Prices.set_amount_of_product("candy",10.0)
	Prices.set_amount_of_product("chocolate",1.0)
	Prices.set_currency("candy")
	
	var best_combidict:Dictionary = calculate_best_combidict(2.0)
	print("best combi: "+ str(best_combidict))
	print("cost: "+ str(Prices.calculate_combidict_price(best_combidict)))
	
	
#	var bad_combi_too_much_candy:Dictionary = {"chocolate": 2, "candy": 50}
#	var trade_result_too_much_candy:Dictionary = calculate_trade_for_combidict(bad_combi_too_much_candy)
#	print("Too much candy result:")
#	print (trade_result_too_much_candy)
	
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _init(satisf_calc_arg:SatisfactionCalculator=null):
	_satisfaction_calculator=satisf_calc_arg

func calculate_trade_for_combidict(combidict_arg:Dictionary)->Dictionary:
	
	var satisfaction:float =_satisfaction_calculator.calculate_satisf_of_combidict(combidict_arg)
	#Prices está en autoload, por lo que lo puedo usar en cualquier lado
	var price:float = Prices.calculate_combidict_price(combidict_arg)
		
	var best_combination:Dictionary = calculate_best_combidict(price)
	var satisfaction_of_best_combination:float = _satisfaction_calculator.calculate_satisf_of_combidict(best_combination)
	
	var combination_diff:Dictionary = {}
	if (satisfaction_of_best_combination > satisfaction):
		combination_diff = calculate_combination_difference(best_combination,combidict_arg)

	return combination_diff

func calculate_best_combidict(money_arg:float)->Dictionary:
#	Debería hacer una versión de este método, que solo recorriese una lista de combinaciones precalculadas
	
#	var best_combination:Dictionary = {}
	var step_length:float = 1.0
	
	var products:Array = Prices.get_products()
	var combination:Dictionary = {}
	for product in products:
		combination[product] = 0
	
	var left_money:float = money_arg
	
#	var best_next_combination:Dictionary = combination.duplicate()
	var count = 0
	var best_previous_satisfaction = 0.0
	while true:
#		print ("left money: "+ str(left_money))	
		var end_calculating = false
		var best_product_combination:Dictionary = {}
		var best_product_satisfaction = 0.0
		var best_product_price = 0.0
		var best_increment_of_satisfaction_for_price:float = 0.0
#		print("count :"+str(count))
		var product_found = false
		for product in products:
			var trying_combination:Dictionary = combination.duplicate()
			trying_combination[product] += step_length
			var satisfaction_of_trying_combination:float = _satisfaction_calculator.calculate_satisf_of_combidict(trying_combination)
			
			var increment_of_satisfaction:float = satisfaction_of_trying_combination - best_previous_satisfaction
			
			var price = Prices.get_price_of_product(product)*step_length
			
#			print("product: "+ product)
#			print("satisf: "+ str(satisfaction_of_trying_combination))
			
			if price<=left_money and increment_of_satisfaction > 0.0:
				product_found = true
				
#				var satisfacton_of_trying_combination_for_price = satisfaction_of_trying_combination/price
				var increment_of_satisfaction_for_price:float = increment_of_satisfaction/price
#				print("satisf/price: "+ str(satisfacton_of_trying_combination_for_price))
#				print("satisf/price: "+ str(increment_of_satisfaction_for_price))
#				print("product: "+ product)
#				print(trying_combination)
#				print ("increment of satisf for price: " + str(increment_of_satisfaction_for_price))
				
				if increment_of_satisfaction_for_price > best_increment_of_satisfaction_for_price:
					best_product_satisfaction = satisfaction_of_trying_combination
					best_product_combination = trying_combination
					best_product_price = price
					best_increment_of_satisfaction_for_price = increment_of_satisfaction_for_price
		
		
		if false==product_found:
			
			break
		
		left_money -= best_product_price
		combination = best_product_combination
		best_previous_satisfaction = best_product_satisfaction
		count += 1
			
	if left_money > 0:
#		Ya no se puede añadir ningún producto, pero puede que quede dinero para intercambiar productos
		while true:
			var change_made = false
			for product_in_combi in products:
				for new_product in products:
					if new_product!=product_in_combi:
						if combination[product_in_combi]>=step_length:
							var trying_combination:Dictionary = combination.duplicate()
						
							trying_combination[product_in_combi] -= step_length
							trying_combination[new_product] += step_length
							var satisfaction_of_trying_combination:float = _satisfaction_calculator.calculate_satisf_of_combidict(trying_combination)
			
							var increment_of_satisfaction:float = satisfaction_of_trying_combination - best_previous_satisfaction
							
							var price = (Prices.get_price_of_product(new_product)-Prices.get_price_of_product(product_in_combi))*step_length
							var almost_zero = 0.000001 
							if left_money-price >= -almost_zero and increment_of_satisfaction > 0.0:
								combination = trying_combination
								change_made = true
								left_money -= price
					if change_made:
						break
				if change_made:
					break	
			
			if false==change_made:
				break
		
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
