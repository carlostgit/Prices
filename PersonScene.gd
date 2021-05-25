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

var _candy:Texture = load("res://candy.png")
var _chocolate:Texture = load("res://chocolate.png")

var _param_max_products_in_ranking:int = 10

signal trade_updated(origin_node,trade_combidict)

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
	
	_satisfaction_calculator = create_satisfaction_calculator()
	_trade_calculator = TradeCalculator.new(_satisfaction_calculator)
	
	var candy_amount:float = _owned_items_dict.get("candy")
	var chocolate_amount:float = _owned_items_dict.get("chocolate")
	$OwnedItems.set_num_candy(candy_amount)
	$OwnedItems.set_num_chocolate(chocolate_amount)
	
#	update_ranking_of_preferences()
	self.call_deferred("update_ranking_of_preferences")

#	$OwnedItems/CandyAmount.set_value(candy_amount)
#	$OwnedItems/ChocolateAmount.set_value(chocolate_amount)
	
#	update_prices()
#	update_after_prices_changed()
	
func get_owned_items()->Dictionary:
	return $OwnedItems/CombinationItem.get_combidict()
	
func update_after_prices_changed()->void:
	$RankingOfPreferences/CombinationSatisfaction.reset_combinations_color()
#	var after_0 = OS.get_ticks_msec()
#	update_ranking_of_preferences()
	self.update_prices_in_ranking_of_preferences()
#	var after_1 = OS.get_ticks_msec()
#	print ("Elapsed update_ranking_of_preferences: "+str( after_1 - after_0))

	update_of_owned_combination()
#	var after_2 = OS.get_ticks_msec()
#	print ("Elapsed update_of_owned_combination: "+str( after_2 - after_1))

	update_best_combination()
#	var after_3 = OS.get_ticks_msec()
#	print ("Elapsed update_best_combination: "+str( after_3 - after_2))

	update_trade()

#	var after_4 = OS.get_ticks_msec()
#	print ("Elapsed update_trade: "+str( after_4 - after_3))

func update_after_owned_combination_changed()->void:
	$RankingOfPreferences/CombinationSatisfaction.reset_combinations_color()
	update_of_owned_combination()
	update_trade()
	update_best_combination()

func create_satisfaction_calculator()->SatisfactionCalculator:
	var satisfaction_calculator:SatisfactionCalculator = SatisfactionCalculator.new()
	satisfaction_calculator.init_default_satisfaction()
	return satisfaction_calculator
	
func set_preference_for_chocolate()->void:
	_satisfaction_calculator.set_preference_for_chocolate()
	self.update_ranking_of_preferences()

func set_default_preference()->void:
	_satisfaction_calculator.set_default_preference()
	self.update_ranking_of_preferences()

func set_preference_for_candy()->void:
	_satisfaction_calculator.set_preference_for_candy()
	self.call_deferred("update_ranking_of_preferences")
#	self.update_ranking_of_preferences()

func update_prices_in_ranking_of_preferences()->void:
	
	#TOO: Cambiar los CombinationItem y los CombinationItemList, para poder cambiar
#	los labels, sin tener que rehacer las combinaciones
	var combidicts:Array = $RankingOfPreferences/CombinationSatisfaction.get_combidicts()
	
#	$RankingOfPreferences/CombinationSatisfaction.update_prices(combidict_prices)
	for combidict in combidicts:
		var price = Prices.calculate_combidict_price(combidict)
		$RankingOfPreferences/CombinationSatisfaction.update_price(combidict,price)
		
func update_ranking_of_preferences()->void:
	var combination_creator = CombinationCreator.new() #Pasar mejor esto a auto load, o como estático
	
#	var time_start = OS.get_ticks_msec()

	var combination_list:CombinationList = combination_creator.calculate_combination_list(_param_max_products_in_ranking)
#	print(combination_list.get_thing_quantity_dict_array())

#	var after_creation = OS.get_ticks_msec()
	
#	var elapsed_time = after_creation - time_start
#	print ("Elapsed time combi creation: "+ str(elapsed_time))
	
	
	var combinations_array:Array = combination_list.get_combinations_array()
	
	var combination_satisfaction_list:CombinationValueList = CombinationValueList.new()
	var combination_price_list:CombinationValueList = CombinationValueList.new()
	for combination in combinations_array:
		var satisf:float = _satisfaction_calculator.calculate_satisf_of_combination(combination)
		combination_satisfaction_list.add_combination_value(combination,satisf)
		var price = Prices.calculate_combination_price(combination)
		combination_price_list.add_combination_value(combination,price)
	
#	var after_satisfaction_and_price_creation = OS.get_ticks_msec()
#	print ("Elapsed time satisf and price calc: "+str(after_satisfaction_and_price_creation-after_creation))
	combination_satisfaction_list.sort()
#	var after_sort = OS.get_ticks_msec()
#	print ("Elapsed sort: "+str(after_sort-after_satisfaction_and_price_creation))
	
	
#	print ("Elapsed sort: "+str(after_satisfaction_and_price_creation))
	
	
#	print ("Elapsed time satisf and price calc: "+str(after_satisfaction_and_price_creation))
	
#	var combination_dict_array_sorted:Array = combination_value_list.get_combination_dict_array()	
#	var combination_satisfaction:Dictionary = {}
#	for combination_dict in combination_dict_array_sorted:
#		var satisf:float = satisfaction_calculator.calculate_satisf_of_combidict(combination_dict)
#		combination_satisfaction[combination_dict] = satisf
#
#	$CombinationSatisfaction.init(combination_dict_array_sorted,combination_satisfaction)
#	TODO: combination_price_list, meterlo en $CombinationSatisfaction
	$RankingOfPreferences/CombinationSatisfaction.init(combination_satisfaction_list, combination_price_list, "Ranking of preferences")
	
#	var after_init = OS.get_ticks_msec()
#	print ("Elapsed init: "+str( after_init - after_sort))

func update_of_owned_combination()->void:
		#Satisfaction of owned combination
	$OwnedItems/CombinationItem.init_with_combidict(_owned_items_dict,"",[])
	
	var owned_combination:Combination = $OwnedItems/CombinationItem.get_combination()
	

	var owned_color:Color = Color( 1, 0.5, 0.31, 1 )
	$RankingOfPreferences/CombinationSatisfaction.highlight_combination_with_color(owned_combination,owned_color)
	
	#focus ranking on owned combination
	$RankingOfPreferences/CombinationSatisfaction.focus_on_combination(owned_combination)
	
	var satisf_of_owned:float = _satisfaction_calculator.calculate_satisf_of_combination(owned_combination)
	$OwnedItems/LabelSatisfaction.set_text("Satisfaction of owned: " + String(satisf_of_owned).pad_decimals(2))

	var value_of_owned:float = Prices.calculate_combidict_price(_owned_items_dict)
	$OwnedItems/LabelValueOfOwned.set_text("Value of owned: "+String(value_of_owned).pad_decimals(2)+ "$")


func get_value_of_owned_combination()->float:
	var value_of_owned:float = Prices.calculate_combidict_price(_owned_items_dict)
	return value_of_owned

#func update_prices()->void:
#	#Precios
##	var combination_prices:CombinationItem = CombinationItem.new()
##	combination_prices.init_with_combidict(Prices.get_combidict(),"Prices",[str(Prices.get_combidict())])
##	combination_prices.set_position(Vector2(300,100))
##	self.add_child(combination_prices)
#	$PricesInfo/LabelCurrency.set_text("Currency: "+Prices.get_currency())
#	$PricesInfo/LabelAmounts.set_text("Prices: "+str(Prices.get_combidict()))
#	var candy_price:float = Prices.get_amount_of_product("candy")
#	var chocolate_price:float = Prices.get_amount_of_product("chocolate")
#	$PricesInfo/CandyAmountForPrice.set_value(candy_price)
#	$PricesInfo/ChocolateAmountForPrice.set_value(chocolate_price)
#
#	update_price_labels()
	#
func update_best_combination()->void:
	#	Best combination
	
	var best_combidict:Dictionary = _trade_calculator.calculate_best_combidict(get_value_of_owned_combination())
	#TODO hacer versión de calculate_best_combidict que busque dentro solo del ranking of preferences
	var combidicts:Array = $RankingOfPreferences/CombinationSatisfaction.get_combidicts()
	var combidict_satisfaction:Dictionary = $RankingOfPreferences/CombinationSatisfaction.get_combidict_satisfaction()
	var combidict_price:Dictionary = $RankingOfPreferences/CombinationSatisfaction.get_combidict_price()
	var best_combidict_from_list:Dictionary = _trade_calculator.calculate_best_combidict_from_list(get_value_of_owned_combination(), combidicts, combidict_satisfaction, combidict_price)
	
	var price_of_combidict_from_list:float = 0.0
	var satisfaction_of_combidict_from_list:float = 0.0
	if (best_combidict_from_list.empty()==false):
		price_of_combidict_from_list = combidict_price[best_combidict_from_list]
		satisfaction_of_combidict_from_list = combidict_satisfaction[best_combidict_from_list]
	#
	
	var best_combination:Combination = Combination.new(best_combidict)
	var best_color:Color = Color( 0, 0.5, 0.5, 1 )
	
	$RankingOfPreferences/CombinationSatisfaction.highlight_combination_with_color(best_combination,best_color)
	$BestCombination/LabelBestCombination.set_text("Best combination: " + str(best_combidict) + "\n From list: " + str(best_combidict_from_list))
	var satisf_of_best_combi:float = _satisfaction_calculator.calculate_satisf_of_combination(best_combination)
	$BestCombination/LabelSatisfaction.set_text("Satisfaction of best combi: " + String(satisf_of_best_combi).pad_decimals(2)+ "\nFrom list: "+str(satisfaction_of_combidict_from_list))
	var value_of_best_combi:float = Prices.calculate_combination_price(best_combination)
	$BestCombination/LabelCost.set_text("Cost: "+ String(value_of_best_combi).pad_decimals(2)+"$"+ "\nFrom list: "+str(price_of_combidict_from_list))

	$BestCombination/CombinationItem.init_with_combidict(best_combidict,"",[])
	
func update_trade()->void:
	var trade_combidict:Dictionary = _trade_calculator.calculate_trade_for_combidict(_owned_items_dict)
	
#	$Trade.trade_combidict = trade_combidict
	
	$Trade.set_trade_combidict(trade_combidict)
	
	$Trade/LabelTrade.set_text("Trade: "+str(trade_combidict))
	
	var trade_combination:Combination = Combination.new(trade_combidict)
	var positive_combidict:Dictionary = trade_combination.get_positive_combination()
##	$Trade.trade_in_combidict = positive_combidict
#
	var negative_combidict:Dictionary = trade_combination.get_negative_combination()
##	$Trade.trade_in_combidict = negative_combidict

##	$Trade/LabelBuyingGoods.set_text("Buying: "+str(positive_combidict))
#
#	var negative_combination:Combination = Combination.new(negative_combidict)
#	negative_combination.set_absolute()
#	$Trade/LabelSellingGoods.set_text("Selling: "+str(negative_combination.get_combidict()))

#	$Trade/CombinationItemBuyingGoods.init_with_combidict(positive_combidict, "in", [])
	

#	$Trade/CombinationItemSellingGoods.init_with_combidict(negative_combination.get_combidict(), "out", [])

#TODO. Probando a poner lo de los productos que se compran y se venden de una manera
#que ocupe menos.
#Igual lo mejor es pintar unas flechas unos iconos y poner un label
#y solo mostrar el icono y flechas cuando toque
#	Prueba
#
#	var candy_image:Image = _candy.get_data()
#	var chocolate_image:Image = _chocolate.get_data()
#	candy_image.resize(20, 20)
#	chocolate_image.resize(20, 20)
#	var reduced_candy_tex:Texture = ImageTexture.new()
#	var reduced_chocolate_tex:Texture = ImageTexture.new()
#	reduced_candy_tex.create_from_image(candy_image)
#	reduced_chocolate_tex.create_from_image(chocolate_image)
#
#	#Mejor quitar los ItemList y poner imágenes (ocultables) y labels
#	$Trade/ItemListBuyingGoods.clear()
#	$Trade/ItemListSellingGoods.clear()
#	if positive_combidict.has("candy"):
#		var num_candy:float =positive_combidict.get("candy")
#		$Trade/ItemListBuyingGoods.add_item(str(num_candy),reduced_candy_tex,false)	
#	if positive_combidict.has("chocolate"):
#		var num_chocolate:float =positive_combidict.get("chocolate")
#		$Trade/ItemListBuyingGoods.add_item(str(num_chocolate),reduced_chocolate_tex,false)
#	if negative_combidict.has("candy"):
#		var num_candy:float =abs(negative_combidict.get("candy"))
#		$Trade/ItemListSellingGoods.add_item(str(num_candy),reduced_candy_tex,false)	
#	if negative_combidict.has("chocolate"):
#		var num_chocolate:float =abs(negative_combidict.get("chocolate"))
#		$Trade/ItemListSellingGoods.add_item(str(num_chocolate),reduced_chocolate_tex,false)


	if positive_combidict.has("candy"):
		var num_candy:float =positive_combidict.get("candy")
		$Trade/LabelCandyBuying.set_text(str(num_candy))
		$Trade/LabelCandyBuying.set_visible(true)
		$Trade/candyBuying.set_visible(true)
	else:
		$Trade/LabelCandyBuying.set_text("0")
		$Trade/LabelCandyBuying.set_visible(false)
		$Trade/candyBuying.set_visible(false)

	if positive_combidict.has("chocolate"):
		var num_chocolate:float =positive_combidict.get("chocolate")
		$Trade/LabelChocolateBuying.set_text(str(num_chocolate))
		$Trade/LabelChocolateBuying.set_visible(true)
		$Trade/chocolateBuying.set_visible(true)
	else:
		$Trade/LabelChocolateBuying.set_text("0")
		$Trade/LabelChocolateBuying.set_visible(false)
		$Trade/chocolateBuying.set_visible(false)

	if negative_combidict.has("candy"):
		var num_candy:float =abs(negative_combidict.get("candy"))
		$Trade/LabelCandySelling.set_text(str(num_candy))	
		$Trade/LabelCandySelling.set_visible(true)
		$Trade/candySelling.set_visible(true)
	else:
		$Trade/LabelCandySelling.set_visible(false)
		$Trade/candySelling.set_visible(false)

	if negative_combidict.has("chocolate"):
		var num_chocolate:float =abs(negative_combidict.get("chocolate"))
		$Trade/LabelChocolateSelling.set_text(str(num_chocolate))
		$Trade/LabelChocolateSelling.set_visible(true)
		$Trade/chocolateSelling.set_visible(true)
	else:
		$Trade/LabelChocolateSelling.set_visible(false)
		$Trade/chocolateSelling.set_visible(false)
		
	if positive_combidict.size()>0:
		$Trade/Polygon2DBuying.set_visible(true)
	else:
		$Trade/Polygon2DBuying.set_visible(false)
	
	if negative_combidict.size()>0:
		$Trade/Polygon2DSelling.set_visible(true)
	else:
		$Trade/Polygon2DSelling.set_visible(false)
	
	
# fin Prueba	
	
	emit_signal("trade_updated",self,trade_combidict)

#func get_trade_out()->Dictionary:
###	var trade_combination_out:Combination = $Trade/CombinationItemSellingGoods.get_combination()
##	var trade_combination_out:Combination = Combination.new($Trade.trade_out_combidict)
###	var trade_combination_in:Combination = $Trade/CombinationItemBuyingGoods.get_combination()
##	var trade_combination_in:Combination =  Combination.new($Trade.trade_in_combidict)
##
##	trade_combination_out.subtract(trade_combination_in)
##	var combidict:Dictionary = trade_combination_out.get_combidict()
##	return combidict
#
#	return $Trade.trade_out_combidict
	
#func update_price_labels()->void:
#	var price_of_candies:float = Prices.get_price_of_product("candy")
#	var price_of_candies_2_dec:String = String(price_of_candies).pad_decimals(2)
#	$PricesInfo/LabelCandyPrice.set_text("="+price_of_candies_2_dec + " candies")
#
#	var price_of_chocolate:float = Prices.get_price_of_product("chocolate")
#	var price_of_chocolate_2_dec:String = String(price_of_chocolate).pad_decimals(2)
#	$PricesInfo/LabelChocolatePrice.set_text("="+price_of_chocolate_2_dec + " candies")
	

#func _on_CandyAmountForPrice_value_changed(value):
#	Prices.set_amount_of_product("candy",value)
#	$PricesInfo/LabelAmounts.set_text("Amounts: "+str(Prices.get_combidict()))
#
#	update_price_labels()
#
#	update_after_prices_changed()
#
#func _on_ChocolateAmountForPrice_value_changed(value):
#	Prices.set_amount_of_product("chocolate",value)
#	$PricesInfo/LabelAmounts.set_text("Amounts: "+str(Prices.get_combidict()))
#
#	update_price_labels()
#
#	update_after_prices_changed()

#func _on_CandyAmount_value_changed(value):
#	_owned_items_dict["candy"] = float(value)
#	self.update_after_owned_combination_changed()
#
#func _on_ChocolateAmount_value_changed(value):
#	_owned_items_dict["chocolate"] = float(value)
#	self.update_after_owned_combination_changed()
	


func _on_PricesInfo_prices_changed():
	update_after_prices_changed()
	pass # Replace with function body.


func _on_ShowInfoRanking_pressed():
	if false==$RankingOfPreferences.is_visible():
		$RankingOfPreferences.show()
	else:
		$RankingOfPreferences.hide()
		$OwnedItems.show()


func _on_Button_pressed():
	$RankingOfPreferences.hide()
	$OwnedItems.show()

func _on_OwnedItems_signal_owned_candy_changed(num):
	_owned_items_dict["candy"] = float(num)
	self.update_after_owned_combination_changed()



func _on_OwnedItems_signal_owned_chocolate_changed(num):
	_owned_items_dict["chocolate"] = float(num)
	self.update_after_owned_combination_changed()
	


func _on_CandyChocolatePrefSlider_value_changed(value):
#	TODO
	var candy_max_satisf:float = 11-value
	var chocolate_max_satisf:float = 1+value
	_satisfaction_calculator.set_max_satisfaction_of_product("chocolate", chocolate_max_satisf)
	_satisfaction_calculator.set_max_satisfaction_of_product("candy", candy_max_satisf)
	update_ranking_of_preferences()

