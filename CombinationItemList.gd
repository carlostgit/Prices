extends Node2D

#class_name CombinationItemList

const Combination = preload("res://Combination.gd")
const CombinationValueList = preload("res://CombinationValueList.gd")
const CombinationItem = preload("res://CombinationItem.gd")
#var _combination_item_scene = preload("res://CombinationItem.tscn")

var _name:String = ""

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var _dibujo_default:Texture = load("res://icon.png")
var _candy:Texture = load("res://candy.png")
var _chocolate:Texture = load("res://chocolate.png")

# Declare member variables here. Examples:
var _products = ["chocolate","candy"]

var _utils = load("res://Utils.gd")

var _combidicts:Array = Array()
var _combidict_satisfaction:Dictionary = Dictionary()
var _combidict_price:Dictionary = Dictionary()

var _combination_items:Array = Array()

var _scale:float = 0.5
var _fixed_icon_size:Vector2 = Vector2(50,50)

var _font = load("res://new_dynamicfont.tres")


# Called when the node enters the scene tree for the first time.
func _ready():
	#self.set_size(Vector2(40,40))
	#comentar lo siguiente cundo esté debugeado
	#init_default_test()
	#$Label.set_text(str($ScrollContainer/Panel))
	
	#
	pass # Replace with function body.


func init_default_test():
#	var default_canvas_item = CanvasItem.new()
	var default_combination_1 = {"chocolate":1, "candy":2}
	var default_combination_2 = {"chocolate":1, "candy":2}
	var default_combination_3 = {"chocolate":1, "candy":2}
	var default_combidicts = [default_combination_1,default_combination_2,default_combination_3]
	
	
	init_with_combidicts(default_combidicts)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
#func _init(canvas_item_arg:CanvasItem, combinations_arg:Array, combination_satisfaction_arg:Dictionary = Dictionary()):
#func _init(canvas_item_arg:CanvasItem, combinations_arg:Array = Array(), combination_satisfaction_arg:Dictionary = Dictionary(),combidict_price_arg:Dictionary = Dictionary(),name_arg:String = "no name"):


func init(combination_satisfaction_list:CombinationValueList, combination_price_list:CombinationValueList=null, name_arg:String = "no name" ):
	if (combination_satisfaction_list as CombinationValueList):
		var combinations:Array = combination_satisfaction_list.get_combinations()
		var combidicts_array:Array = []
		var combidict_satisfaction:Dictionary = {}
		var combidict_price:Dictionary = {}
		for combination in combinations:
			var combidict:Dictionary = (combination as Combination).get_combidict()
			combidicts_array.append(combidict)
			var satisf:float = combination_satisfaction_list.get_value_of_combination(combination)
			combidict_satisfaction[combidict]=satisf
			
			#price
			if (null!=combination_price_list):
				if combination_price_list.has_combination(combination):
					var price:float = combination_price_list.get_value_of_combination(combination)
					combidict_price[combidict]=price
			#
			
		init_with_combidicts(combidicts_array, combidict_satisfaction,combidict_price,name_arg)
	else:
		assert(false)

#func init(combidicts_arg:Array, combidict_satisfaction_dict_arg:Dictionary):
#	_init(combidicts_arg, combidict_satisfaction_dict_arg)


func init_with_combidicts(combidicts_arg:Array = Array(), combidict_satisfaction_dict_arg:Dictionary = Dictionary(),combidict_price_arg:Dictionary = Dictionary(),name_arg:String = "no_name"):

	remove_combination_items()	#Se borran los nodos CombinationItem
	reset_combidicts() #Se borra la info de cominaciones
		
	_combidict_satisfaction = combidict_satisfaction_dict_arg
	_combidict_price = combidict_price_arg	
	_combidicts = combidicts_arg
	
	for combidict in _combidicts:
		assert(typeof(combidict)==TYPE_DICTIONARY)
		add_item_list(combidict)

	#Label 1
	self.set_name(name_arg)
	var label_name:Label = Label.new()
	label_name.set_scale(Vector2(1.5,1.5))
	label_name.set_text(self.get_name())
	label_name.set("custom_colors/font_color", Color(1,0,0))
	label_name.set_position(self.get_position()+Vector2(0,0))
	label_name.add_to_group("removable")
	#$ScrollContainer/Panel.add_child(label_name)
	self.add_child(label_name)
	
	#Si tiene título, bajo un poco la posición del ScrollContainer, para dejar hueco al título
	if (name_arg != ""):
		$ScrollContainer.set_position(Vector2(0,30))
	
	#Label 2
	if _combination_items.size()>0:
		var item_width:float = _combination_items.back().get_width()   #.get_width()
		var right_end_position_x = self.get_position().x+_combination_items.size()*item_width
		
		var label_count = 0
		var labels:Array =["Satisfaction","Price"]
		for label in labels:

			assert(typeof(label)==TYPE_STRING)
			var satisf_label:Label = Label.new()
			satisf_label.set_scale(Vector2(1.0,1.0))
			satisf_label.set_text(label)
			satisf_label.set("custom_colors/font_color", Color(1,0,0))
			var satisf_posit = self.get_position()+Vector2(right_end_position_x+20,50-30*label_count)
			satisf_label.set_position(satisf_posit)
			satisf_label.add_to_group("removable")
			$ScrollContainer/Panel.add_child(satisf_label)
			
			label_count += 1


func set_name(name_arg:String)->void:
	_name = name_arg


func get_name()->String:
	return _name


func get_combidicts()->Array:
	return self._combidicts


func reset_combinations_color()->void:
	for combination_item in self._combination_items:
#		var combination_dict:Dictionary = combination_item.get_combination_dict()
		var combination:Combination = combination_item.get_combination()
		combination_item.highlight(Color(0,0,0,0))


func focus_on_combination(combination_to_focus_arg:Combination)->void:
	for combination_item in self._combination_items:
#		var combination_dict:Dictionary = combination_item.get_combination_dict()
		var combination:Combination = combination_item.get_combination()
		if combination.equals(combination_to_focus_arg):
			var combi_pos:Vector2 = combination_item.get_position()
			var h_scrollbar = $ScrollContainer.get_h_scrollbar()
			h_scrollbar.set_value(combi_pos.x)
	

func highlight_combination_with_color(combination_to_highlight_arg:Combination, color_arg:Color)->void:
	for combination_item in self._combination_items:
#		var combination_dict:Dictionary = combination_item.get_combination_dict()
		var combination:Combination = combination_item.get_combination()
		if combination.equals(combination_to_highlight_arg):
			combination_item.highlight(color_arg)
			
			#Todo: poner lo siguiente en método aparte
			#Metodo focus combination
#			var combi_pos:Vector2 = combination_item.get_position()
#			var h_scrollbar = $ScrollContainer.get_h_scrollbar()
#			h_scrollbar.set_value(combi_pos.x)
			#

func highlight_combidict_with_color(combidict_to_highlight_arg:Dictionary, color_arg:Color)->void:
	for combination_item in self._combination_items:
		var combination_dict:Dictionary = combination_item.get_combidict()
		if Utils.compare_dictionaries(combination_dict,combidict_to_highlight_arg):
			combination_item.highlight(color_arg)


func get_ordered_combidicts(combination_satisfaction_arg:Dictionary) -> Array:
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

	
func add_item_list(combidict_arg:Dictionary):
	
	var satisf:float = 0
	if(_combidict_satisfaction.size()>0):
		satisf = _combidict_satisfaction[combidict_arg]
	
	var price:float = 0
	if(_combidict_price.size()>0):
		price = _combidict_price[combidict_arg]
	
	var combination_labels:Array = []
	combination_labels.append(String(satisf).pad_decimals(1))
	combination_labels.append(String(price).pad_decimals(2) + "$")	
#	Método 1, mediante clases
#	var combination_item:CombinationItem = CombinationItem.new(combidict_arg, "", combination_labels)
#	Pruebo a hacer lo anterior con instancias de escenas, en vez de clases
#	Método 2, instanciando escenas
#	var combination_item = _combination_item_scene.instance()
	var combination_item:CombinationItem = CombinationItem.new()
	combination_item.init_with_combidict(combidict_arg, "", combination_labels)
	var item_width:float = combination_item.get_width()
	var current_position_x = self.get_position().x+_combination_items.size()*item_width
	var this_item_list_pos=Vector2(current_position_x,self.get_position().y+40)
	combination_item.set_position(this_item_list_pos)
	self._combination_items.append(combination_item)
	combination_item.add_to_group("removable")
	$ScrollContainer/Panel.call_deferred("add_child",combination_item)

	pass

func remove_combination_items()->void:
	_combination_items.clear()
	
	for child in $ScrollContainer/Panel.get_children():
		if child.is_in_group("removable"):
			$ScrollContainer/Panel.remove_child(child)
			child.queue_free()
			
	for child in self.get_children():
		if child.is_in_group("removable"):
			self.remove_child(child)
			child.queue_free()

func reset_combidicts()->void:
	_combidict_satisfaction = {}
	_combidict_price = {}	
	_combidicts = []

