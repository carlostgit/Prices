extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal prices_changed

# Called when the node enters the scene tree for the first time.
func _ready():
#	update_prices()
#	update_after_prices_changed()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func update_prices()->void:
	#Precios
#	var combination_prices:CombinationItem = CombinationItem.new()
#	combination_prices.init_with_combidict(Prices.get_combidict(),"Prices",[str(Prices.get_combidict())])
#	combination_prices.set_position(Vector2(300,100))
#	self.add_child(combination_prices)
	$LabelCurrency.set_text("Currency: "+Prices.get_currency())
	$LabelAmounts.set_text("Prices: "+str(Prices.get_combidict()))
	var candy_price:float = Prices.get_amount_of_product("candy")
	var chocolate_price:float = Prices.get_amount_of_product("chocolate")
	$CandyAmountForPrice.set_value(candy_price)
	$ChocolateAmountForPrice.set_value(chocolate_price)
	
	update_price_labels()


func update_price_labels()->void:
	var price_of_candies:float = Prices.get_price_of_product("candy")
	var price_of_candies_2_dec:String = String(price_of_candies).pad_decimals(2)
	$LabelCandyPrice.set_text("="+price_of_candies_2_dec + " candies")
	
	var price_of_chocolate:float = Prices.get_price_of_product("chocolate")
	var price_of_chocolate_2_dec:String = String(price_of_chocolate).pad_decimals(2)
	$LabelChocolatePrice.set_text("="+price_of_chocolate_2_dec + " candies")


func _on_CandyAmountForPrice_value_changed(value):
	Prices.set_amount_of_product("candy",value)
	$LabelAmounts.set_text("Amounts: "+str(Prices.get_combidict()))
	
	update_price_labels()
	
	update_after_prices_changed()

func _on_ChocolateAmountForPrice_value_changed(value):
	Prices.set_amount_of_product("chocolate",value)
	$LabelAmounts.set_text("Amounts: "+str(Prices.get_combidict()))
	
	update_price_labels()
	
	update_after_prices_changed()
	
func update_after_prices_changed():
	emit_signal("prices_changed")
	pass
	#avisar a los consumidores, que los precios han cambiado


func _on_MainScene_ready():
	update_prices()
	update_after_prices_changed()
	pass # Replace with function body.
