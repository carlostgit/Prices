extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const Combination = preload("res://Combination.gd")
#var character_node = Character.new()

var _combinations_array:Array = []

# Called when the node enters the scene tree for the first time.
func _ready():

	var dict1 = {"chocolate":2.2,"candy":1.1 }
	var dict2 = {"chocolate":2.2,"candy":1.1 }
	var dict3 = {"chocolate":2.21,"candy":1.1 }
	
	add_combination(Combination.new(dict1))
	add_combination(Combination.new(dict2))
	add_combination(Combination.new(dict3))
	
	print (get_thing_quantity_dict_array())
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

#func add_thing_quantity(thing_quantity_dict_arg:Dictionary)->void:
#	add_combination(Combination.new(thing_quantity_dict_arg))
	
func add_combination(combination_arg:Combination)->void:
	_combinations_array.append(combination_arg)
	
func has_combination(combination_arg:Combination)->bool:
	for combination in _combinations_array:
		if combination.equals(combination_arg):
			return true
	return false
	
func get_combinations_array()->Array:
	return _combinations_array

func get_thing_quantity_dict_array()->Array:
	var return_array = []
	for combination in _combinations_array:
		return_array.append(combination.get_thing_quantity_dict())
	return return_array
