extends Node2D

const Combination = preload("res://Combination.gd")
const CombinationItem = preload("res://CombinationItem.gd")
const CombinationCreator = preload("res://CombinationCreator.gd")
const CombinationList = preload("res://CombinationList.gd")
const SatisfactionCalculator = preload("res://SatisfactionCalculator.gd")
const CombinationValueList = preload("res://CombinationValueList.gd")
const TradeCalculator = preload("res://TradeCalculator.gd")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
#	Owned items
	var owned_items_dict = {"chocolate":1, "candy":2}
	$OwnedItems.init_with_combidict(owned_items_dict,"owned",["",""])

#	CombinationSatisfactionList
	
	var satisfaction_calculator:SatisfactionCalculator = SatisfactionCalculator.new()
	satisfaction_calculator.init_default_satisfaction()

	var combination_creator = CombinationCreator.new() #Pasar mejor esto a auto load, o como estático
	var combination_list:CombinationList = combination_creator.calculate_combination_list(5)
#	print(combination_list.get_thing_quantity_dict_array())
	
	var combinations_array:Array = combination_list.get_combinations_array()
	
	var combination_satisfaction_list:CombinationValueList = CombinationValueList.new()
	var combination_price_list:CombinationValueList = CombinationValueList.new()	
	for combination in combinations_array:
		var satisf:float = satisfaction_calculator.calculate_satisf_of_combination(combination)
		combination_satisfaction_list.add_combination_value(combination,satisf)
		var price = Prices.calculate_combination_price(combination)
		combination_price_list.add_combination_value(combination,price)
	combination_satisfaction_list.sort()
	
#	var combination_dict_array_sorted:Array = combination_value_list.get_combination_dict_array()	
#	var combination_satisfaction:Dictionary = {}
#	for combination_dict in combination_dict_array_sorted:
#		var satisf:float = satisfaction_calculator.calculate_satisf_of_combidict(combination_dict)
#		combination_satisfaction[combination_dict] = satisf
#
#	$CombinationSatisfaction.init(combination_dict_array_sorted,combination_satisfaction)
#	TODO: combination_price_list, meterlo en $CombinationSatisfaction
	$CombinationSatisfaction.init(combination_satisfaction_list, combination_price_list, "Ranking of preferences")


	#Voy a resaltar la combinación actual
	var owned_combination:Combination = $OwnedItems.get_combination()
	var owned_color:Color = Color( 1, 0.5, 0.31, 1 ) 
	$CombinationSatisfaction.highlight_combination_with_color(owned_combination,owned_color)
	
	#Precios
	var combination_prices:CombinationItem = CombinationItem.new()
	combination_prices.init_with_combidict(Prices.get_combidict(),"Prices",[str(Prices.get_combidict())])
	combination_prices.set_position(Vector2(300,100))
	self.add_child(combination_prices)
	#
	
	var value_of_owned:float = Prices.calculate_combidict_price(owned_items_dict)
	$LabelValueOfOwned.set_text(String(value_of_owned).pad_decimals(2)+ "$")

	var trade_calculator:TradeCalculator = TradeCalculator.new(satisfaction_calculator)
	var best_combidict:Dictionary = trade_calculator.calculate_best_combidict(value_of_owned)
	var best_combination:Combination = Combination.new(best_combidict)
	var best_color:Color = Color( 0, 0.5, 0.5, 1 ) 
	$CombinationSatisfaction.highlight_combination_with_color(best_combination,best_color)
	

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
