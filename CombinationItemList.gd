extends Node2D

#class_name CombinationItemList

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
#var _MyDictionary = load("res://MyDictionary.gd")

var _combinations:Array = Array()
var _combination_satisfaction:Dictionary = Dictionary()
var _combination_price:Dictionary = Dictionary()

#var _canvas_item:CanvasItem = null
var _combination_items:Array = Array()

#var _combination_item_list:Dictionary = Dictionary()

var _scale:float = 0.5
var _fixed_icon_size:Vector2 = Vector2(50,50)

var _font = load("res://new_dynamicfont.tres")

var _combination_item_scene = preload("res://CombinationItem.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	#self.set_size(Vector2(40,40))
#	init_default_test()
	pass # Replace with function body.


func init_default_test():
#	var default_canvas_item = CanvasItem.new()
	var default_combination_1 = {"chocolate":1, "candy":2}
	var default_combination_2 = {"chocolate":1, "candy":2}
	var default_combination_3 = {"chocolate":1, "candy":2}
	var default_combinations = [default_combination_1,default_combination_2,default_combination_3]
	
	
	_init(default_combinations)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
#func _init(canvas_item_arg:CanvasItem, combinations_arg:Array, combination_satisfaction_arg:Dictionary = Dictionary()):
#func _init(canvas_item_arg:CanvasItem, combinations_arg:Array = Array(), combination_satisfaction_arg:Dictionary = Dictionary(),combination_price_arg:Dictionary = Dictionary(),name_arg:String = "no name"):

func init(combinations_arg:Array, combination_satisfaction_arg:Dictionary):
	_init(combinations_arg, combination_satisfaction_arg)

func _init(combinations_arg:Array = Array(), combination_satisfaction_arg:Dictionary = Dictionary(),combination_price_arg:Dictionary = Dictionary(),name_arg:String = "no name"):
#	_canvas_item = canvas_item_arg
	#_combinations = combinations_arg
	_combination_satisfaction = combination_satisfaction_arg
	_combination_price = combination_price_arg
	
	_combinations = combinations_arg
	#_combinations = get_ordered_combinations(combination_satisfaction_arg)
	
	for combination in _combinations:
		assert(typeof(combination)==TYPE_DICTIONARY)
		add_item_list(combination)
	
	self.set_name(name_arg)
	print("label_name is")
	var label_name:Label = Label.new()
	label_name.set_scale(Vector2(1.5,1.5))
	label_name.set_text(self.get_name())
	label_name.set("custom_colors/font_color", Color(1,0,0))
	#label_name.set_text("Pruebita")
	#print(self.get_name())
	label_name.set_position(self.get_position()+Vector2(0,0))
	#print ("position is")
	print (label_name.get_position())
	self.add_child(label_name)
	
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
			self.add_child(satisf_label)
			label_count += 1
		

func set_name(name_arg:String)->void:
	_name = name_arg

func get_name()->String:
	return _name

func get_combinations()->Array:
	return self._combinations


func highlight_combination_with_color(combination_to_highlight_arg:Dictionary, color_arg:Color)->void:
	for combination_item in self._combination_items:
		var combination_dict:Dictionary = combination_item.get_combination_dict()
		if Utils.compare_dictionaries(combination_dict,combination_to_highlight_arg):
			combination_item.highlight(color_arg)


func get_ordered_combinations(combination_satisfaction_arg:Dictionary) -> Array:
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
	
func add_item_list(combination_dict_arg:Dictionary):
	
	var satisf:float = 0
	if(_combination_satisfaction.size()>0):
		satisf = _combination_satisfaction[combination_dict_arg]
	
	var price:float = 0
	if(_combination_price.size()>0):
		price = _combination_price[combination_dict_arg]
	
	
	var combination_labels:Array = []
	combination_labels.append(String(satisf).pad_decimals(1))
	combination_labels.append(String(price).pad_decimals(1))	
#	Método 1, mediante clases
#	var combination_item:CombinationItem = CombinationItem.new(combination_dict_arg, "", combination_labels)
#	Pruebo a hacer lo anterior con instancias de escenas, en vez de clases
#	Método 2, instanciando escenas
	var combination_item = _combination_item_scene.instance()
	combination_item.init(combination_dict_arg, "", combination_labels)
	var item_width:float = combination_item.get_width()
	var current_position_x = self.get_position().x+_combination_items.size()*item_width
	var this_item_list_pos=Vector2(current_position_x,self.get_position().y+20)
	combination_item.set_position(this_item_list_pos)
	self._combination_items.append(combination_item)
	self.add_child(combination_item)
	
		
		
	
	pass

