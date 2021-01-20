
class_name Utils


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

static func compare_dictionaries(dict_1:Dictionary,dict_2:Dictionary)-> bool:
	#Este método casero es necesario, porque en la versión de gdscript actual
	#no funciona bien la comparación (operador==) entre objetos Dictionary
	if(dict_1.size()!=dict_2.size()):
		return false
		
	for key in dict_1.keys():
		if false==dict_2.has(key):
			return false
		if dict_1[key] != dict_2[key]:
			return false
		
	return true
	
static func find_value_in_dictionary_with_dictionary_key(dict_with_dictionary_key_arg:Dictionary,dict_key_arg:Dictionary):
	#Este método casero es necesario, porque en la versión de gdscript actual
	#no funciona bien la comparación (operador==) entre objetos Dictionary
		
	for dictionary_key in dict_with_dictionary_key_arg:
		if compare_dictionaries(dictionary_key, dict_key_arg):
			return dict_with_dictionary_key_arg[dictionary_key]
	
	return null
	
static func get_ordered_combinations(combination_satisfaction_arg:Dictionary) -> Array:
	#Se ordenano de menor a mayor satisfacción
	
	var satisfactions_ordered:Array = combination_satisfaction_arg.values()
	satisfactions_ordered.sort()
	var combi_satisf_left = combination_satisfaction_arg.duplicate(true) #copia
	var combinations_ordered:Array = Array()
	for satisfaction in satisfactions_ordered:
		for combination in combi_satisf_left:
			if satisfaction == combi_satisf_left[combination]:
				combinations_ordered.append(combination)
				combi_satisf_left.erase(combination)
				break	
	assert(combination_satisfaction_arg.size()==combinations_ordered.size())

	return combinations_ordered
