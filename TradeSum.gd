extends Control

const Combination = preload("res://Combination.gd")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

#export(NodePath) var node_path1
#export(NodePath) var node_path2
#
#var _person1:Node = null
#var _person2:Node = null

#var _person1_trade_combidict = {}
#var _person2_trade_combidict = {}
var _array_of_person_trade_combidict = []
var _sum_of_trade_combidict = {}

var _min_price_of_chocolate_found:bool = false
var _min_price_of_chocolate:float = 0.0
var _max_price_of_chocolate_found:bool = false
var _max_price_of_chocolate:float = 0.0

var _persons_trade_updated:Array = []
var _num_of_persons = 2

var _testing_prices:bool = false

signal decrease_chocolate_price
signal increase_chocolate_price
# Called when the node enters the scene tree for the first time.
func _ready():
#	_person1 = get_node(node_path1)
#	_person2 = get_node(node_path2)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func update_sum_trades()->void:
#	var trade1_combination:Combination = Combination.new(_person1_trade_combidict)
#	var trade2_combination:Combination = Combination.new(_person2_trade_combidict)
	var trade_combination_sum:Combination = Combination.new()
	for person_trade_combidict in self._array_of_person_trade_combidict:
		var trade_combination:Combination = Combination.new(person_trade_combidict)
		trade_combination_sum.sum(trade_combination)
	
	_sum_of_trade_combidict = trade_combination_sum.get_combidict()
	
#	trade1_combination.sum(trade2_combination)
#	_sum_of_trade_combidict = trade1_combination.get_combidict()
	
	$SumOfAllTrades.set_text(str(_sum_of_trade_combidict))
	
	sum_of_all_trades_updated(_sum_of_trade_combidict)
	
func sum_of_all_trades_updated(sum_of_trade_combidict_arg:Dictionary)->void:
	
	var chocolate_too_cheap:bool = false
	var chocolate_too_expensive:bool = false
	var candy_amount:float = 0.0
	var chocolate_amount:float = 0.0
	
	if sum_of_trade_combidict_arg.has("candy"):
		candy_amount = sum_of_trade_combidict_arg.get("candy")
		if (candy_amount>0):
			chocolate_too_expensive = true
		elif (candy_amount<0):
			chocolate_too_cheap = true
			
	if sum_of_trade_combidict_arg.has("chocolate"):
		chocolate_amount = sum_of_trade_combidict_arg.get("chocolate")
		if (chocolate_amount>0):
			chocolate_too_cheap = true
		elif (chocolate_amount<0):
			chocolate_too_expensive = true
			
	#Se podía dar el caso de que candy_amount y chocolate_amount tengan el mismo signo
	var error:bool = false	
	if candy_amount>0 and chocolate_amount>0:
		error = true
	elif candy_amount<0 and chocolate_amount<0:
		error = true
#	
	
	if chocolate_too_expensive:
		$PricesResult.set_text("Chocolate too expensive")		
		var current_price_of_chocolate:float = Prices.get_price_of_product("chocolate")
		if current_price_of_chocolate < _max_price_of_chocolate or false == _max_price_of_chocolate_found:
			_max_price_of_chocolate = current_price_of_chocolate
			$MaxPrice.set_text("Max price choc.: "+str(_max_price_of_chocolate))
			_max_price_of_chocolate_found = true
	elif chocolate_too_cheap:
		$PricesResult.set_text("Chocolate too cheap")
		var current_price_of_chocolate:float = Prices.get_price_of_product("chocolate")
		if current_price_of_chocolate > _min_price_of_chocolate or false == _min_price_of_chocolate_found:
			_min_price_of_chocolate = current_price_of_chocolate
			$MinPrice.set_text("Min price choc.: "+str(_min_price_of_chocolate))
			_min_price_of_chocolate_found = true
	else:
		$PricesResult.set_text("")
		
	if error:
		var old_text:String = $PricesResult.get_text()
		$PricesResult.set_text(old_text + " error")

#func _on_PersonScene1_trade_updated(origin_node, trade_combidict):
#	_person1_trade_combidict = trade_combidict
#	$SumTradePerson1Label.set_text(str(trade_combidict))
##	update_sum_trades()
#	person_trade_updated(origin_node)

#func _on_PersonScene2_trade_updated(origin_node, trade_combidict):
#	_person2_trade_combidict = trade_combidict
#	$SumTradePerson2Label.set_text(str(trade_combidict))
##	update_sum_trades()
#	person_trade_updated(origin_node)
	
func _on_PersonScene_trade_updated(origin_node, trade_combidict):
	var person_trade_combidict = {}
	person_trade_combidict = trade_combidict
	self._array_of_person_trade_combidict.append(person_trade_combidict)
#	$SumTradePerson2Label.set_text(str(trade_combidict))
#	update_sum_trades()
	person_trade_updated(origin_node)

func person_trade_updated(person_node_arg:Node):
	if false == _persons_trade_updated.has(person_node_arg):
		_persons_trade_updated.append(person_node_arg)	
	if _persons_trade_updated.size() == _num_of_persons:
		update_sum_trades()
		_persons_trade_updated.clear()

func _on_ResetButton_pressed():
	reset_prices_info()
	
func reset_prices_info():
	_min_price_of_chocolate_found = false
	_min_price_of_chocolate = 0.0
	_max_price_of_chocolate_found = false
	_max_price_of_chocolate = 0.0
	
	$MaxPrice.set_text("Max price")
	$MinPrice.set_text("Min price")
	$PricesResult.set_text("Result")
	$SumOfAllTrades.set_text("SumOfAllTrades")
	$SumTradePerson2Label.set_text("SumTradePerson2Label")
	$SumTradePerson1Label.set_text("SumTradePerson1Label")
	
	_persons_trade_updated.clear()

func _on_TestPricesButton_pressed():
	#TODO:
#	Mi idea es hacer un test de precios, para encontrar el precio mínimo y máximo
#	Mandar señales de establecimiento de precios,
#	que tendrá que recoger PricesInfo para cambiar precios
#	Dejar de mandar las señales de cambio de precios cuando se haya encontrado la información
	reset_prices_info()
	_testing_prices = true
	$TimerTestPrices.start()

	pass # Replace with function body.


func _on_TimerTestPrices_timeout():
	if (_testing_prices):
		var price_of_chocolate = Prices.get_amount_of_product("chocolate")
		var price_of_candy = Prices.get_amount_of_product("candy")
		if (false == _min_price_of_chocolate_found):
			emit_signal("decrease_chocolate_price")
		elif (false == _max_price_of_chocolate_found):
			emit_signal("increase_chocolate_price")
			
		if(_min_price_of_chocolate_found and _max_price_of_chocolate_found):
			_testing_prices = false
			$TimerTestPrices.stop()
		
	pass # Replace with function body.

func _on_MainScene_signal_num_persons_updated(num):
	self._num_of_persons = num
