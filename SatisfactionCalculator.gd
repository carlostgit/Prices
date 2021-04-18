extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

#var _param_preference_at_0 = {"chocolate": 2.16, "candy": 4.5}
#var _maximum_satisf = {"chocolate": 10.0, "candy": 4.0}

const Combination = preload("res://Combination.gd")

var _combos:Dictionary = {"sweets":["chocolate","candy"]}
#var _param_combo_preference_at_0 = {"sweets":10.8}
#var _param_combo_maximum_quantity_satisf = {"sweets":3.0}

var _products = ["chocolate","candy"]

const Plotter = preload("res://Plotter.gd")
const SatisfactionCurve = preload("res://SatisfactionCurve.gd")

var _product_satisf_curve_dict:Dictionary = {}
var _combo_satisf_curve_dict:Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():

#	var test_combination:Dictionary = {"chocolate": 2, "candy": 2}	
#	print(calculate_satisf_of_combidict(test_combination))

#	var param_max_satisf:float = 10
#	var param_quantity:float = 10
#	var param_satisf_at_1:float = 5
#	var preference_at_0 = calculate_param_preference_at_0(param_max_satisf, param_satisf_at_1, param_quantity)
#	_param_preference_at_0["chocolate"] = preference_at_0
#	_maximum_satisf["chocolate"] = param_max_satisf

	var plotter:Plotter = Plotter.new(10,15)
	plotter.set_size(Vector2(300,300))
	plotter.updated_size()
#	var dimin_ret_fact_func_ref:FuncRef = funcref( self, "get_diminishing_returns_factor")
#	plotter.add_func_ref(dimin_ret_fact_func_ref,"dimin_ret_fact")
	self.call_deferred("add_child",plotter)
	
#	print(calculate_param_preference_at_0(10, 1, 1))

#	var satis_curve_chocolate:SatisfactionCurve = SatisfactionCurve.new(0.56,10)
#	var satis_curve_candy:SatisfactionCurve = SatisfactionCurve.new(10,4)
#	var satis_curve_sweets:SatisfactionCurve = SatisfactionCurve.new(10.8,15)
#
#	_product_satisf_curve_dict["chocolate"]=satis_curve_chocolate
#	_product_satisf_curve_dict["candy"]=satis_curve_candy
#	_combo_satisf_curve_dict["sweets"]=satis_curve_sweets

	#init_default_satisfaction()
	init_candy_satisfaction()
	
	plotter.add_func_ref(funcref( self, "calculate_satifaction_of_chocolate"),"chocolate")
	plotter.add_func_ref(funcref( self, "calculate_satifaction_of_candy"),"candy")
	plotter.add_func_ref(funcref( self, "calculate_satifaction_of_sweets"),"sweets")

	var combi = {"chocolate": 10.0, "candy": 10.0}
	print("satisf_combi: " + str(self.calculate_satisf_of_combidict(combi)))
	var combi_2 = {"chocolate": 11.0, "candy": 9.0}
	print("satisf_combi_2: " + str(self.calculate_satisf_of_combidict(combi_2)))
	
	
##test funcs
func calculate_satifaction_of_chocolate(quantity_arg:float) -> float:
	return calculate_satifaction_of_product("chocolate",quantity_arg)
func calculate_satifaction_of_candy(quantity_arg:float) -> float:
	return calculate_satifaction_of_product("candy",quantity_arg)
func calculate_satifaction_of_sweets(quantity_arg:float) -> float:
	return calculate_satifaction_of_prod_combo("sweets",quantity_arg)
##


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _init():
	init_default_satisfaction()
	
func reset()->void:
	_product_satisf_curve_dict.clear()
	_combo_satisf_curve_dict.clear()

func set_preference_for_chocolate():
	reset()
	init_chocolate_satisfaction()

func set_preference_for_candy():
	reset()
	init_candy_satisfaction()

func set_default_preference():
	reset()
	init_default_satisfaction()

	
func init_default_satisfaction():
	var satis_curve_chocolate:SatisfactionCurve = SatisfactionCurve.new(2.16,10)
	var satis_curve_candy:SatisfactionCurve = SatisfactionCurve.new(2.2,14)
	var satis_curve_sweets:SatisfactionCurve = SatisfactionCurve.new(1.8, 1)
	
	_product_satisf_curve_dict["chocolate"]=satis_curve_chocolate
	_product_satisf_curve_dict["candy"]=satis_curve_candy
	_combo_satisf_curve_dict["sweets"]=satis_curve_sweets

func init_candy_satisfaction():
	var satis_curve_chocolate:SatisfactionCurve = SatisfactionCurve.new(2.16,8)
	var satis_curve_candy:SatisfactionCurve = SatisfactionCurve.new(4.2,18)
	var satis_curve_sweets:SatisfactionCurve = SatisfactionCurve.new(1.8, 1)
	
	_product_satisf_curve_dict["chocolate"]=satis_curve_chocolate
	_product_satisf_curve_dict["candy"]=satis_curve_candy
	_combo_satisf_curve_dict["sweets"]=satis_curve_sweets

func init_chocolate_satisfaction():
	var satis_curve_chocolate:SatisfactionCurve = SatisfactionCurve.new(2.4,20)
	var satis_curve_candy:SatisfactionCurve = SatisfactionCurve.new(2.2,10)
	var satis_curve_sweets:SatisfactionCurve = SatisfactionCurve.new(1.8, 1)
	
	_product_satisf_curve_dict["chocolate"]=satis_curve_chocolate
	_product_satisf_curve_dict["candy"]=satis_curve_candy
	_combo_satisf_curve_dict["sweets"]=satis_curve_sweets

	
func calculate_satisf_of_combination(combination_arg:Combination):
	if combination_arg as Combination:
		var combination_dict:Dictionary = combination_arg.get_combidict()
		return calculate_satisf_of_combidict(combination_dict)
	else:
		assert(false)

func calculate_satisf_of_combidict(combidict_arg:Dictionary) -> float:
	var satisfaction_return = 0.0
	
	var satisf_of_prod_individually = 0.0
	for product in self._products:
		var amount_of_product = combidict_arg[product]
		satisf_of_prod_individually += self.calculate_satifaction_of_product(product,amount_of_product)
#		var satisf_curve:SatisfactionCurve = _product_satisf_curve_dict[product]
#		satisf_of_prod_individually += satisf_curve.calculate_satifaction(amount_of_product)

	var satisf_of_combi = 0.0
	for combi_name in self._combos.keys():
		var amount_of_combi = 0
		var count = 0
		for product in _combos[combi_name]:
			var amount_of_product = combidict_arg[product]
			if amount_of_product < amount_of_combi or 0 == count:
				amount_of_combi = amount_of_product
			count += 1
		satisf_of_combi += self.calculate_satifaction_of_prod_combo(combi_name,amount_of_combi)

	satisfaction_return = satisf_of_prod_individually+satisf_of_combi		
		
#	print("indiv: "+str(satisf_of_prod_individually))
#	print("combi: "+str(satisf_of_combi))
	
	return satisfaction_return

#func calculate_satisfaction_of_combination(combination:Dictionary) -> float:
#	#Satisfaction of individual products
#	#{candy:3, chocolate:0}
#	var satisfaction:float = 0.0
#
#	for prod in combination.keys():
#		var num_of_prod:float = combination[prod]
#		if num_of_prod > 0.0:
#			var satisf_of_prod = calculate_satifaction_of_product(prod,num_of_prod)
#			satisfaction += satisf_of_prod
#
#	#Satisfaction of combos
#	var satisf_combos:float = calculate_satisfaction_of_prod_combos_in_combination(combination)
#
#	return satisfaction+satisf_combos

#func calculate_satisfaction_of_prod_combos_in_combination(combidict:Dictionary) -> float:
#	#Satisfaction of individual products
#	#{candy:3, chocolate:0}
#	var satisfaction:float = 0.0
#
#	#var _combo = {"sweets":["chocolate","candy"]}
#	for combo in self._combos.keys():
#		var dict_prod_of_combo_repetitions:Dictionary = Dictionary()
#		var prods_in_combo:Array = _combos[combo]
#		for prod in prods_in_combo:
#			dict_prod_of_combo_repetitions[prod] = 0.0
#
##		print ("dict_prod_of_combo_repetitions:")
##		print (dict_prod_of_combo_repetitions)
#
#		for prod in combidict.keys():
#			var num_of_prod:float = combidict[prod]
#			if num_of_prod > 0.0:
#				if dict_prod_of_combo_repetitions.has(prod):
#					dict_prod_of_combo_repetitions[prod] = num_of_prod
#
##		print ("dict_prod_of_combo_repetitions 2:")
##		print (dict_prod_of_combo_repetitions)
#
#
#		var min_of_comb_in_combination:float = 0.0
#		if (dict_prod_of_combo_repetitions.size()>0):
#			var first_prod:bool = true
#			for prod in dict_prod_of_combo_repetitions.keys():
#				var num_of_repet = dict_prod_of_combo_repetitions[prod]
#				if first_prod:
#					min_of_comb_in_combination = num_of_repet
#					first_prod = false
#				if num_of_repet < min_of_comb_in_combination:
#					min_of_comb_in_combination = num_of_repet
#		else:
#			min_of_comb_in_combination = 0.0
#
##		print ("min_of_comb_in_combination:")
##		print (min_of_comb_in_combination)
#
#
#		if min_of_comb_in_combination > 0.0:
#			var satisf_of_combo_in_combination = calculate_satifaction_of_prod_combo(combo, min_of_comb_in_combination)
#			satisfaction += satisf_of_combo_in_combination
#
#	return satisfaction

func calculate_satifaction_of_product(product_arg:String, quantity_arg:float) -> float:
	
	if false==_products.has(product_arg):
		return 0.0
	
	var ret_satisf = 0.0
#	var pref_at_0 = _param_preference_at_0[product_arg]
#	var max_satisf = _maximum_satisf[product_arg]
#
#	ret_satisf = max_satisf*get_diminishing_returns_factor(quantity_arg*pref_at_0/max_satisf)
	
	var product_satisf_curve:SatisfactionCurve = self._product_satisf_curve_dict[product_arg]
	ret_satisf = product_satisf_curve.calculate_satifaction(quantity_arg)
	
	return ret_satisf

func calculate_satifaction_of_prod_combo(combo_arg:String, quantity_arg:float) -> float:
	
	if false==self._combos.has(combo_arg):
		return 0.0
	
	var ret_satisf = 0.0
#	var pref_at_0 = self._param_combo_preference_at_0[combi_arg]
#	var max_satisf = self._param_combo_maximum_quantity_satisf[combi_arg]
#
#	ret_satisf = max_satisf*get_diminishing_returns_factor(quantity_arg*pref_at_0/max_satisf)
#
	var combo_satisf_curve:SatisfactionCurve = self._combo_satisf_curve_dict[combo_arg]
	ret_satisf = combo_satisf_curve.calculate_satifaction(quantity_arg)
	
	return ret_satisf

#func get_diminishing_returns_factor(quantity_arg:float) -> float:
#	#Voy a llamar al termino "1-(1/(0.25*x+1)^2)" Diminishing Returns Factor
#	#Esta ecuación tendría un máximo en 1, y tendría pendiente 1 en 0
#	#Es como una ecuación y = x, pero que se va haciendo más y más horizontal hasta q ya no crece la y
#	var result = 0.0
#	var denominator_square_root = 0.25*quantity_arg + 1.0;
#	var denominator = denominator_square_root*denominator_square_root
#	result = 1.0 - (1.0/denominator)
#	if result < 0:
#		result = 0
#	return result

#static func calculate_param_preference_at_0(max_satisfaction_arg:float, param_point_satisfaction_arg:float, param_point_quantity_arg:float)->float:
#	#
#	var coefficient_q:float = 0.25*param_point_quantity_arg/max_satisfaction_arg
#	var coefficient_z:float = param_point_satisfaction_arg-max_satisfaction_arg
#	var coefficient_qq:float = coefficient_q*coefficient_q
#
#	var coefficient_sqrt:float = sqrt(-4*coefficient_qq*max_satisfaction_arg/coefficient_z)
#
#	var preference_at_0:float = (-2*coefficient_q+coefficient_sqrt)/(2*coefficient_qq)
#
#	return preference_at_0
