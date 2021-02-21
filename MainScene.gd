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
var _satisfaction_calculator:SatisfactionCalculator = null
var _owned_items_dict = {"chocolate":1, "candy":2}
var _trade_calculator:TradeCalculator = null

# Called when the node enters the scene tree for the first time.
func _ready():
#	Owned items
#	var owned_items_dict = {"chocolate":1, "candy":2}
	init()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func init()->void:
	$OwnedItems/CombinationItem.init_with_combidict(_owned_items_dict,"owned",["",""])
	_satisfaction_calculator = create_satisfaction_calculator()
	_trade_calculator = TradeCalculator.new(_satisfaction_calculator)
	
	update_prices()
	update_after_prices_changed()
	
	
func update_after_prices_changed()->void:
	update_ranking_of_preferences()
	update_of_owned_combination()
	update_best_combination()
	update_trade()


func create_satisfaction_calculator()->SatisfactionCalculator:
	var satisfaction_calculator:SatisfactionCalculator = SatisfactionCalculator.new()
	satisfaction_calculator.init_default_satisfaction()
	return satisfaction_calculator

func update_ranking_of_preferences()->void:
	var combination_creator = CombinationCreator.new() #Pasar mejor esto a auto load, o como estático
	var combination_list:CombinationList = combination_creator.calculate_combination_list(5)
#	print(combination_list.get_thing_quantity_dict_array())
	
	var combinations_array:Array = combination_list.get_combinations_array()
	
	var combination_satisfaction_list:CombinationValueList = CombinationValueList.new()
	var combination_price_list:CombinationValueList = CombinationValueList.new()	
	for combination in combinations_array:
		var satisf:float = _satisfaction_calculator.calculate_satisf_of_combination(combination)
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
	$RankingOfPreferences/CombinationSatisfaction.init(combination_satisfaction_list, combination_price_list, "Ranking of preferences")

func update_of_owned_combination()->void:
		#Satisfaction of owned combination
	var owned_combination:Combination = $OwnedItems/CombinationItem.get_combination()
	var owned_color:Color = Color( 1, 0.5, 0.31, 1 ) 
	$RankingOfPreferences/CombinationSatisfaction.highlight_combination_with_color(owned_combination,owned_color)
	var satisf_of_owned:float = _satisfaction_calculator.calculate_satisf_of_combination(owned_combination)
	$OwnedItems/LabelSatisfaction.set_text("Satisfaction of owned: " + String(satisf_of_owned).pad_decimals(2))

	var value_of_owned:float = Prices.calculate_combidict_price(_owned_items_dict)
	$OwnedItems/LabelValueOfOwned.set_text("Value of owned: "+String(value_of_owned).pad_decimals(2)+ "$")

func get_value_of_owned_combination()->float:
	var value_of_owned:float = Prices.calculate_combidict_price(_owned_items_dict)
	return value_of_owned

func update_prices()->void:
	#Precios
#	var combination_prices:CombinationItem = CombinationItem.new()
#	combination_prices.init_with_combidict(Prices.get_combidict(),"Prices",[str(Prices.get_combidict())])
#	combination_prices.set_position(Vector2(300,100))
#	self.add_child(combination_prices)
	$Prices/LabelCurrency.set_text("Currency: "+Prices.get_currency())
	$Prices/LabelPrices.set_text("Prices: "+str(Prices.get_combidict()))
	var candy_price:float = Prices.get_amount_of_product("candy")
	var chocolate_price:float = Prices.get_amount_of_product("chocolate")
	$Prices/CandyPrice.set_value(candy_price)
	$Prices/ChocolatePrice.set_value(chocolate_price)
	#
func update_best_combination()->void:
	#	Best combination
	
	var best_combidict:Dictionary = _trade_calculator.calculate_best_combidict(get_value_of_owned_combination())
	var best_combination:Combination = Combination.new(best_combidict)
	var best_color:Color = Color( 0, 0.5, 0.5, 1 ) 
	$RankingOfPreferences/CombinationSatisfaction.highlight_combination_with_color(best_combination,best_color)
	$BestCombination/LabelBestCombination.set_text("Best combination: " + str(best_combidict))
	var satisf_of_best_combi:float = _satisfaction_calculator.calculate_satisf_of_combination(best_combination)
	$BestCombination/LabelSatisfaction.set_text("Satisfaction of best combi: " + String(satisf_of_best_combi).pad_decimals(2))
	var value_of_best_combi:float = Prices.calculate_combination_price(best_combination)
	$BestCombination/LabelCost.set_text("Cost: "+ String(value_of_best_combi).pad_decimals(2)+"$")

func update_trade()->void:
	var trade_combidict:Dictionary = _trade_calculator.calculate_trade_for_combidict(_owned_items_dict)
	$Trade/LabelTrade.set_text("Trade: "+str(trade_combidict))




func _on_CandyPrice_value_changed(value):
	Prices.set_amount_of_product("candy",value)
	$Prices/LabelPrices.set_text("Prices: "+str(Prices.get_combidict()))
	update_after_prices_changed()


func _on_ChocolatePrice_value_changed(value):
	Prices.set_amount_of_product("chocolate",value)
	$Prices/LabelPrices.set_text("Prices: "+str(Prices.get_combidict()))
	update_after_prices_changed()
