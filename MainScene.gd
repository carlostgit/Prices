extends Node2D

const CombinationCreator = preload("res://CombinationCreator.gd")
const CombinationList = preload("res://CombinationList.gd")
const Combination = preload("res://Combination.gd")
const SatisfactionCalculator = preload("res://SatisfactionCalculator.gd")
const CombinationValueList = preload("res://CombinationValueList.gd")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
#	Owned items
	var owned_items_dict = {"chocolate":1, "candy":2}
	$OwnedItems.init(owned_items_dict,"owned",["",""])

#	CombinationSatisfactionList
	
	var satisfaction_calculator:SatisfactionCalculator = SatisfactionCalculator.new()
	satisfaction_calculator.init_default_satisfaction()

	var combination_creator = CombinationCreator.new() #Pasar mejor esto a auto load, o como estático
	var combination_list:CombinationList = combination_creator.calculate_combination_list(5)
#	print(combination_list.get_thing_quantity_dict_array())
	
	var combinations_array:Array = combination_list.get_combinations_array()
	
	var combination_value_list:CombinationValueList = CombinationValueList.new()
	for combination in combinations_array:
#		var combination_dict = combination.get_thing_quantity_dict()
#		var satisf:float = satisfaction_calculator.calculate_satisf(combination_dict)
		var satisf:float = satisfaction_calculator.calculate_satisf_of_combination(combination)
		combination_value_list.add_combination_value(combination,satisf)
	
	combination_value_list.sort()
	
#	var combination_dict_array_sorted:Array = combination_value_list.get_combination_dict_array()	
#	var combination_satisfaction:Dictionary = {}
#	for combination_dict in combination_dict_array_sorted:
#		var satisf:float = satisfaction_calculator.calculate_satisf(combination_dict)
#		combination_satisfaction[combination_dict] = satisf
#
#	$CombinationSatisfaction.init(combination_dict_array_sorted,combination_satisfaction)
	$CombinationSatisfaction.init_with_combination_value_list(combination_value_list)

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
