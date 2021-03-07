extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var _thing_quantity_dict:Dictionary = {} #combidict

# Called when the node enters the scene tree for the first time.
func _ready():
	
	var dict1 = {"chocolate":2.2,"candy":1.1 }
	var dict2 = {"chocolate":2.2,"candy":1.1 }
	var dict3 = {"chocolate":2.21,"candy":1.1 }
	var dict4 = {"chocolat":2.2,"candy":1.1 }
	
	init(dict1)
	
	print("dict1 equals dict2 ?")
	print(self.equals(dict2))
	
	print("dict1 equals dict3 ?")
	print(self.equals(dict3))
	
	print("dict1 equals dict4 ?")
	print(self.equals(dict4))
	
	print("compatibles?")
	print(self.is_compatible(dict2))
	print(self.is_compatible(dict3))
	print(self.is_compatible(dict4))
	
	
	print(self.get_quantity_of_thing("chocolate"))
	print(self.get_quantity_of_thing("candy"))
	print(self.get_array_of_things())
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
#
func _init(thing_quantity_dict_arg={}): #Sin ={}, me aparece un error al lanzar la escena
	init(thing_quantity_dict_arg)
	
func init(thing_quantity_dict_arg:Dictionary)->void:
	for thing in thing_quantity_dict_arg.keys():
		assert(typeof(thing)==TYPE_STRING)
		assert(typeof(thing_quantity_dict_arg[thing])==TYPE_REAL or typeof(thing_quantity_dict_arg[thing])==TYPE_INT)
		
	_thing_quantity_dict = thing_quantity_dict_arg
	
func get_combidict()->Dictionary:
	return _thing_quantity_dict
	
func get_quantity_of_thing(thing_arg:String)->float:
	return _thing_quantity_dict[thing_arg]

func get_array_of_things()->Array:
	return _thing_quantity_dict.keys()
	
func is_compatible(thing_quantity_dict_arg:Dictionary)->bool:
	if (thing_quantity_dict_arg.size() and _thing_quantity_dict.size()):
		if thing_quantity_dict_arg.keys() == _thing_quantity_dict.keys():
			return true
	return false

func equals_dict(thing_quantity_dict_arg:Dictionary)->bool:
	if (thing_quantity_dict_arg.size() and _thing_quantity_dict.size()):
		if thing_quantity_dict_arg.keys() == _thing_quantity_dict.keys():
			for thing in thing_quantity_dict_arg.keys():
				if false==(thing in _thing_quantity_dict):
					return false;
				else:
					if thing_quantity_dict_arg[thing] != _thing_quantity_dict[thing]:
						return false
		else:
			return false			
	else:
		return false
#	Finished testing
	return true

func equals(combination_arg)->bool:
	var thing_quantity_dict:Dictionary = combination_arg.get_combidict()
	if (thing_quantity_dict.size() and _thing_quantity_dict.size()):
		var thing_quantity_dict_sorted:Array = thing_quantity_dict.keys()
		thing_quantity_dict_sorted.sort()
		var self_thing_quantity_dict_sorted:Array = _thing_quantity_dict.keys()
		self_thing_quantity_dict_sorted.sort()
		if thing_quantity_dict_sorted == self_thing_quantity_dict_sorted:
			for thing in thing_quantity_dict.keys():
				if false==(thing in _thing_quantity_dict):
					return false;
				else:
					if thing_quantity_dict[thing] != _thing_quantity_dict[thing]:
						return false
		else:
			return false			
	else:
		return false
#	Finished testing
	return true

func get_positive_combination()->Dictionary:
	var positive_dict:Dictionary = {}
	for prod in _thing_quantity_dict.keys():
		if _thing_quantity_dict.get(prod) > 0.0:
			positive_dict[prod] = _thing_quantity_dict.get(prod)			
	return positive_dict
	
func get_negative_combination()->Dictionary:
	
	var negative_dict:Dictionary = {}
	for prod in _thing_quantity_dict.keys():
		if _thing_quantity_dict.get(prod) < 0.0:
			negative_dict[prod] = _thing_quantity_dict.get(prod)			
	return negative_dict
	
func set_positive()->void:
	for prod in _thing_quantity_dict.keys():
		_thing_quantity_dict[prod] = abs(_thing_quantity_dict.get(prod))
