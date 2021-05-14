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
#var _products = ["chocolate","candy"]
var _products = Globals._products
var _utils = load("res://Utils.gd")

var _combidicts:Array = Array()
var _combidict_satisfaction:Dictionary = Dictionary()
var _combidict_price:Dictionary = Dictionary()

#var _combidict_satisflabel:Dictionary = {}
#var _combidict_pricelabel:Dictionary = {}

var _combination_items:Array = Array()
var _combidict_combinationitem:Dictionary = {}

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
#	var time_1:float = OS.get_ticks_msec()
	if (combination_satisfaction_list as CombinationValueList):
		var combinations:Array = combination_satisfaction_list.get_combinations()
#		var time_1a:float = OS.get_ticks_msec()
#		print ("elaped_time_1a = "+ str(time_1a-time_1))
#		var elaped_time_1a:float = time_1a-time_1
		var combidicts_array:Array = []
		var combidict_satisfaction:Dictionary = {}
		var combidict_price:Dictionary = {}
		
#		var elaped_time_1:float = 0.0
#		var elaped_time_2:float = 0.0
		for combination in combinations:
#			var time_1_1:float = OS.get_ticks_msec()
			var combidict:Dictionary = (combination as Combination).get_combidict()
			combidicts_array.append(combidict)
			#El método sospechoso de tardar mucho es get_value_of_combination
			var satisf:float = combination_satisfaction_list.get_value_of_combination(combination)
			#
			combidict_satisfaction[combidict]=satisf
#			var time_1_2:float = OS.get_ticks_msec()
			
			#price
			if (null!=combination_price_list):
				if combination_price_list.has_combination(combination):
					var price:float = combination_price_list.get_value_of_combination(combination)
					combidict_price[combidict]=price
			#
#			var time_1_3:float = OS.get_ticks_msec()
#
#			elaped_time_1 += time_1_2-time_1_1
#
#			elaped_time_2 += time_1_3-time_1_2
#		print ("elaped_time_1 = "+ str(elaped_time_1))
#
#		print ("elaped_time_2 = "+ str(elaped_time_2))
			
		init_with_combidicts(combidicts_array, combidict_satisfaction,combidict_price,name_arg)
	else:
		assert(false)

#	var time_2:float = OS.get_ticks_msec()
#	print ("Time 1a = "+ str(time_2-time_1))
	
#func init(combidicts_arg:Array, combidict_satisfaction_dict_arg:Dictionary):
#	_init(combidicts_arg, combidict_satisfaction_dict_arg)


func init_with_combidicts(combidicts_arg:Array = Array(), combidict_satisfaction_dict_arg:Dictionary = Dictionary(),combidict_price_arg:Dictionary = Dictionary(),name_arg:String = "no_name"):
	
#	var time_1:float = OS.get_ticks_msec()
#
#	print("self.get_child_count(): "+ str(self.get_child_count()))
#	print("$ScrollContainer.get_child_count(): "+ str($ScrollContainer.get_child_count()))
#	print("$ScrollContainer/Panel.get_child_count(): "+ str($ScrollContainer/Panel.get_child_count()))

	for child in $ScrollContainer.get_children():
		print(str(child))
	
	remove_combination_items()	#Se borran los nodos CombinationItem
	reset_combidicts() #Se borra la info de cominaciones
	
#	print("after remove self.get_child_count(): "+ str(self.get_child_count()))
#	print("after remove $ScrollContainer.get_child_count(): "+ str($ScrollContainer.get_child_count()))
#	print("after remove $ScrollContainer/Panel.get_child_count(): "+ str($ScrollContainer/Panel.get_child_count()))
	
	_combidict_satisfaction = combidict_satisfaction_dict_arg
	_combidict_price = combidict_price_arg	
	_combidicts = combidicts_arg
	
	for combidict in _combidicts:
		assert(typeof(combidict)==TYPE_DICTIONARY)
		add_item_list(combidict)
	
#	var time_2:float = OS.get_ticks_msec()

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

#	var time_3:float = OS.get_ticks_msec()
#	print ("Time 1 = "+ str(time_2-time_1))
#	print ("Time 2 = "+ str(time_3-time_2))

	
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

	var satisf_label:String = String(satisf).pad_decimals(1)
	var price_label:String = String(price).pad_decimals(2) + "$"
#	_combidict_satisflabel[combidict_arg] = satisf_label
#	_combidict_pricelabel[combidict_arg] = price_label
#
	var combination_labels:Array = []
	combination_labels.append(satisf_label)
	combination_labels.append(price_label)	



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
	_combidict_combinationitem[combidict_arg]=combination_item
	combination_item.add_to_group("removable")
	$ScrollContainer/Panel.add_child(combination_item)
#	$ScrollContainer/Panel.call_deferred("add_child",combination_item)
#	Nota importante. Hay un problema si se usa el call_deferred. Con el call_deferred, acaba habiendo items duplicados
#	Creo que lo que ocurre es que se vueve a crear otro item del mismo tipo, antes de que se cree este item con el call_deferred
#

	pass
	

func remove_combination_items()->void:
	_combination_items.clear()
	_combidict_combinationitem.clear()
	
	for child in $ScrollContainer/Panel.get_children():
		if child.is_in_group("removable"):
			$ScrollContainer/Panel.remove_child(child)
			child.queue_free()
			
	for child in $ScrollContainer.get_children():
		if child.is_in_group("removable"):
			$ScrollContainer.remove_child(child)
			child.queue_free()
	
			
	for child in self.get_children():
		if child.is_in_group("removable"):
			self.remove_child(child)
			child.queue_free()

func reset_combidicts()->void:
	_combidict_satisfaction = {}
	_combidict_price = {}	
	_combidicts = []
	_combination_items = []
	_combidict_combinationitem = {}

func get_combidict_satisfaction()->Dictionary:
	return _combidict_satisfaction

func get_combidict_price()->Dictionary:
	return _combidict_price

func update_price(combidict_arg:Dictionary,price_arg:float):
	if (_combidict_combinationitem.has(combidict_arg)):
		
		self._combidict_price[combidict_arg] = price_arg
		update_labels(combidict_arg)

func update_labels(combidict_arg):
	if (_combidict_combinationitem.has(combidict_arg)):
		var combination_item:CombinationItem = _combidict_combinationitem[combidict_arg]
		var satisf:float = self._combidict_satisfaction[combidict_arg]
		var price:float = self._combidict_price[combidict_arg]
		var satisf_label:String = String(satisf).pad_decimals(1)
		var price_label:String = String(price).pad_decimals(2) + "$"
		combination_item.update_labels("",[satisf_label,price_label])
		
