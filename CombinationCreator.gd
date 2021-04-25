extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const Combination = preload("res://Combination.gd")
const CombinationList = preload("res://CombinationList.gd")

var _products:Array = ["chocolate","candy"]

# Called when the node enters the scene tree for the first time.
func _ready():
	
#	print(calculate_combidicts_old(10))

#	print(calculate_combination_list(10))
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func calculate_combination_list(max_num_elements_arg:int)->CombinationList:
	#Devuelve array de Combination. Por ejemplo:
	var num_elements_combidicts_dict:Dictionary = calculate_num_elem_combidicts_dict_old(max_num_elements_arg)
	var combinations_array:Array = Array()
	for key in num_elements_combidicts_dict.keys():
		combinations_array += num_elements_combidicts_dict[key]

	var combination_list:CombinationList = CombinationList.new()
	for combination_dict in combinations_array:
		var combination:Combination = Combination.new(combination_dict)
		combination_list.add_combination(combination)

	return combination_list


func calculate_combidicts_old(max_num_elements_arg:int)->Array:
	#Devuelve array de diccionarios. Por ejemplo:
	#[{candy:1, chocolate:0},#1 
	#{candy:0, chocolate:1},
	#{candy:2, chocolate:0},#2 
	#{candy:1, chocolate:1}, 
	#{candy:0, chocolate:2}]
	var num_elements_combidicts_dict:Dictionary = calculate_num_elem_combidicts_dict_old(max_num_elements_arg)
	var combinations_array:Array = Array()
	for key in num_elements_combidicts_dict.keys():
		combinations_array += num_elements_combidicts_dict[key]
	return combinations_array

func calculate_num_elem_combidicts_dict_old(max_num_elements_arg:int)->Dictionary:
	#Devuelve diccionario, de array de diccionarios. Algo como:
	#{1,[{candy:1, chocolate:0}, 
		#{candy:0, chocolate:1}]},
	#{2,[{candy:2, chocolate:0}, 
		#{candy:1, chocolate:1}, 
		#{candy:0, chocolate:2}]},
	#{3,[{candy:3, chocolate:0}, 
		#{candy:2, chocolate:1}, 
		#{candy:1, chocolate:2}, 
		#{candy:0, chocolate:3}]}
	var combination_dict = Dictionary()
	for num_elem in range(1,max_num_elements_arg+1):
		var combination_list_of_exact_number_of_elements = calculate_combidicts_exact_num_of_elem_old(num_elem,self._products)
		combination_dict[num_elem] = combination_list_of_exact_number_of_elements;
		assert(typeof(num_elem)==TYPE_INT)
		assert(typeof(combination_list_of_exact_number_of_elements) == TYPE_ARRAY)
	
	return combination_dict

func calculate_combidicts_exact_num_of_elem_old(exact_num_elements_arg:int, list_of_prod:Array)->Array:
	#Devuelve Array de dictionaries
	#[{candy:3, chocolate:0}, {candy:2, chocolate:1}, {candy:1, chocolate:2}, {candy:0, chocolate:3}]

	var combination_list = Array()
	var used_products = Array()
	
	if list_of_prod.size()>0:
		var prod = list_of_prod.front()

		var rest_of_products = list_of_prod.duplicate(true) #copia del array
		used_products.append(prod)
		for used_prod in used_products:
			rest_of_products.erase(used_prod)

		for num in range(0,exact_num_elements_arg+1):
			
			var subcombination_list = Array()
			if rest_of_products.size() > 0:

				subcombination_list = calculate_combidicts_exact_num_of_elem_old(exact_num_elements_arg-num,rest_of_products)

				for dict in subcombination_list:
					dict[prod] = num

				for elem in subcombination_list:
					combination_list.append(elem)
				
			else:
				if (num==exact_num_elements_arg):
					var dict_prod_num = { prod:num}
					
					subcombination_list.append(dict_prod_num)

					for elem in subcombination_list:
						combination_list.append(elem)

					break
					
	return combination_list
	
