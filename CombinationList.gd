extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

#Creo que esta clase debería desaparecer!!!!
#Es mejor no guardar objetos Combination en arrays
#Es mejor tener arrays o diccionarios de Combidicts

const Combination = preload("res://Combination.gd")
#var character_node = Character.new()

var _combidicts_set:Dictionary = {} #A falta de std::set, voy a usar un Dictionary
var _combinations_array:Array = []

# Called when the node enters the scene tree for the first time.
func _ready():

	var dict1 = {"chocolate":2.2,"candy":1.1 }
	var dict2 = {"chocolate":2.2,"candy":1.1 }
	var dict3 = {"chocolate":2.21,"candy":1.1 }
	
	add_combination(Combination.new(dict1))
	add_combination(Combination.new(dict2))
	add_combination(Combination.new(dict3))
	
#	print (get_combidict_array())
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

#func add_thing_quantity(thing_quantity_dict_arg:Dictionary)->void:
#	add_combination(Combination.new(thing_quantity_dict_arg))
	
func add_combination(combination_arg:Combination)->void:
	if combination_arg as Combination:
#		var class_of_combination_arg = combination_arg.get_class()
#		assert(class_of_combination_arg=="Combination")
		_combinations_array.append(combination_arg)
		_combidicts_set[combination_arg.get_combidict()] = 0
	else:
		assert(false)
		
func has_combination_old(combination_arg:Combination)->bool:
	#Este metodo es muy lento
	for combination in _combinations_array:
		if combination.equals(combination_arg):
			return true
	return false

func has_combination(combination_arg:Combination)->bool:
	return _combidicts_set.has(combination_arg.get_combidict())
	
	
func get_combinations_array()->Array:
	return _combinations_array

#func get_combidict_array()->Array:
#	var return_array = []
#	for combination in _combidicts_array:
#		return_array.append(combination.get_combidict())
#	return return_array
