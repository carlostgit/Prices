extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const SatisfactionCalculator = preload("res://SatisfactionCalculator.gd")

var _satisfaction_calculator:SatisfactionCalculator = null

# Called when the node enters the scene tree for the first time.
func _ready():
	
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
	
	#TODO
	var best_combination:Dictionary = calculate_best_combination(price)
	var satisfaction_of_best_combination:float = best_combination.calculate_satisf()
	
	var combination_diff:Dictionary = calculate_combination_difference(best_combination,satisfaction)

	return combination_diff
