extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const Combination = preload("res://Combination.gd")

var _combination_value_array:Array = []

class CombinationValue:
	var _combination_value:Dictionary = {}
	func _init(combination_arg:Combination=null, value_arg:float=0):
		_combination_value["combination"]=combination_arg
		_combination_value["value"]=value_arg
	func get_dict()->Dictionary:
		return _combination_value
	func get_combination()->Combination:
		return _combination_value["combination"]
	func get_value()->float:
		return _combination_value["value"]
		
class CombinationValueSorter:
	static func sort(combination_value_a:CombinationValue, combination_value_b:CombinationValue):
		if (combination_value_a.get_value() < combination_value_b.get_value()):
			return true
		else:
			return false
# Called when the node enters the scene tree for the first time.
func _ready():
	
#	var dict1 = {"chocolate":2.2,"candy":1.1 }
#	var dict2 = {"chocolate":2.2,"candy":1.1 }
#	var dict3 = {"chocolate":2.21,"candy":1.1 }
#
#	add_combination_value(Combination.new(dict1),5)
#	add_combination_value(Combination.new(dict2),2)
#	add_combination_value(Combination.new(dict3),3)
#
#	print(get_thing_quantity_value_array())
#
#	self.sort()
#
#	print(get_thing_quantity_value_array())
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func add_combination_value(combination_arg:Combination, value_arg:float)->void:
	var combination_value:CombinationValue = CombinationValue.new(combination_arg,value_arg)
#	combination_value["combination"] = combination_arg
#	combination_value["value"] = value_arg
	_combination_value_array.append(combination_value)
	
func has_combination(combination_arg:Combination)->bool:
	for combination_value in _combination_value_array:
		var combination:Combination = combination_value.get_combination()
		if combination.equals(combination_arg):
			return true
	return false
	
func get_combinations()->Array:
	var combis:Array = []
	for combination_value in _combination_value_array:
		var combination:Combination = (combination_value as CombinationValue).get_combination()
		combis.append(combination)
	return combis
	
func get_combination_value_array()->Array:
	return _combination_value_array

func get_combination_dict_array()->Array:
	var combination_dict_array:Array = []
	for combination_value in _combination_value_array:
		var combination:Combination = combination_value.get_combination()
		var thing_quantity_dict:Dictionary = combination.get_thing_quantity_dict()
		combination_dict_array.append(thing_quantity_dict)

	return combination_dict_array

func get_thing_quantity_value_array()->Array:
	var return_array = []
	for combination_value in _combination_value_array:
		var combination:Combination = combination_value.get_combination()
		var thing_quantity_dict:Dictionary = combination.get_thing_quantity_dict()
		var value:float = combination_value.get_value()
		
		var thing_quantity_value_dict:Dictionary = {}
		thing_quantity_value_dict["thing_quantity"]=thing_quantity_dict
		thing_quantity_value_dict["value"]=value
		
		return_array.append(thing_quantity_value_dict)
	return return_array


func get_thing_quantity_dict_array()->Array:
	var return_array = []
	for combination_value in _combination_value_array:
		var combination:Combination = combination_value.get_combination()
		return_array.append(combination.get_thing_quantity_dict())
	return return_array

func sort()->void:
	_combination_value_array.sort_custom(CombinationValueSorter,"sort")

func get_value_of_combination(combination_arg:Combination)->float:
	for combination_value in _combination_value_array:
		var combination:Combination = (combination_value as CombinationValue).get_combination()
		if (combination_arg.equals(combination)):
			return (combination_value as CombinationValue).get_value()

	return 0.0
