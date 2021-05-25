extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const Combination = preload("res://Combination.gd")
#var _canvas_item:CanvasItem = null

var _dibujo_default:Texture = load("res://icon.png")
var _candy:Texture = load("res://candy.png")
var _chocolate:Texture = load("res://chocolate.png")
var _part_candy:Texture = load("res://part_candy.png")
var _part_chocolate:Texture = load("res://part_chocolate.png")


# Declare member variables here. Examples:
#var _persons = ["Pepe", "Paco"]
#var _products = ["chocolate","candy"]
var _products = Globals._products

var _scale:float = 0.2
var _fixed_icon_size:Vector2 = Vector2(64,64)

#var _arguments:Array = []

var _combination_dict:Dictionary = Dictionary()

var _item_list:ItemList = null

var _combination_name_label:Label
var _combination_extra_labels:Array = []

const _param_space_for_name:float = 10.0
const _param_space_for_extra_label:float = 40.0

const _default_height:float = 200.0
#const _default_width:float = 64.0

# Called when the node enters the scene tree for the first time.
func _ready():
#	print ("test CombinationItem!!")
#	init_default_test()
#	print(self.get_size().y)
##
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	print("_item_list.get_size()")
#	print(_item_list.get_size())
#	print(_fixed_icon_size.y*self._scale)
#	pass

func init_default_test():
#	var default_canvas_item = CanvasItem.new()
	var default_combidict = {"chocolate":2, "candy":5}
	_combination_dict = default_combidict

	init_with_combidict(default_combidict,"combi_name",["lbl1","lbl2"])
	

func init_with_combidict(combidict_arg:Dictionary = Dictionary(), name_arg:String = "", labels_arg:Array = Array()):
#	_canvas_item = canvas_item_arg
	_combination_dict = combidict_arg
	#TODO
	
	for child in self.get_children():
		self.remove_child(child)
		child.queue_free()
	
	_item_list = null
	
#	_combination_name_label = name_arg
#	_combination_extra_labels = labels_arg
	
	#Dibujar una combinación, con la posibilidad de acompañarla de un valor
	add_items_and_labels(combidict_arg, name_arg, labels_arg)

	

func _init(combidict_arg:Dictionary = Dictionary(), name_arg:String = "", labels_arg:Array = Array()):
##	_canvas_item = canvas_item_arg
#	_combination_dict = combidict_arg
#
#	#TODO
#	#Dibujar una combinación, con la posibilidad de acompañarla de un valor
#	add_item_list(combidict_arg, labels_arg)
#
#	self.set_label(name_arg)
#	if (0==self.get_size().x && 0==self.get_size().y):
#		self.set_size(Vector2(self._default_width, self._default_height))
	
	pass
	
func add_name_label(label_name_arg:String)->void:
#	print("label_name is")
	var label_name:Label = Label.new()
	label_name.set_scale(Vector2(1.0,1.0))
	label_name.set_text(label_name_arg)
	label_name.set("custom_colors/font_color", Color(1,0.5,0.5))
	#label_name.set_text("Pruebita")
	#print(self.get_name())
	label_name.set_position(Vector2(0,0))

	self.add_child(label_name)
	_combination_name_label = label_name

#
func add_items_and_labels(combidict_arg:Dictionary, label_name_arg:String, labels_arg:Array):

#	print("add_items_and_labels"+ str(combidict_arg))

	for label in labels_arg:
		assert(typeof(label)==TYPE_STRING)

	var total_num_products:float = 0.0
	for product in combidict_arg.keys():
		var num_current_prod:float = combidict_arg[product]
		total_num_products += ceil(num_current_prod)

	var item_list:ItemList = ItemList.new()

	var space_for_labels = calculate_space_for_labels(label_name_arg,labels_arg)
	var parent_x_pos = self.get_position().x
	var parent_y_pos = self.get_position().y
	
	var fraction:float = 1.0
	if total_num_products*_fixed_icon_size.y*self._scale > _default_height:
		fraction = _default_height/(total_num_products*_fixed_icon_size.y*self._scale)
		

	item_list.set_size(Vector2(_fixed_icon_size.x*self._scale + 5 , 1))

	item_list.set_fixed_icon_size(Vector2(_fixed_icon_size.x ,_fixed_icon_size.y*fraction))

	var chocolate_fraction_icon:ImageTexture = get_image_texture_fraction(_chocolate,_fixed_icon_size.y*fraction)
	var candy_fraction_icon:ImageTexture = get_image_texture_fraction(_candy,_fixed_icon_size.y*fraction)
	var default_fraction_icon:ImageTexture = get_image_texture_fraction(_dibujo_default,_fixed_icon_size.y*fraction)

	var num_item=0

	for product in combidict_arg.keys():
		var num_current_prod:float = combidict_arg[product]
		var num_int_current_prod:int = floor(num_current_prod)
		var partial_prod_amount = num_current_prod - num_int_current_prod

		var icon =null
		if(product == "chocolate"):
			icon = chocolate_fraction_icon
		elif (product == "candy"):
			icon = candy_fraction_icon
		else:
			icon = default_fraction_icon
			assert(false)

		for pro in num_int_current_prod:
			item_list.add_icon_item(icon)
			num_item +=  1

		if partial_prod_amount>0:			
			var image : Image = icon.get_data()
			image.lock()
			for x in image.get_width():
				if partial_prod_amount > (float(x)/float(image.get_width())):
					for y in image.get_height():
						image.set_pixel(x,y,Color(0,0,0,0))
			image.unlock()
			var texture = ImageTexture.new()
			texture.create_from_image(image)
			item_list.add_icon_item(texture)
			num_item += 1

	var this_item_list_pos=Vector2(0, 0 + space_for_labels)
	item_list.set_position(this_item_list_pos)
	item_list.set_auto_height(true)

#	item_list.set_icon_scale(_scale)
	item_list.set_icon_scale(_scale)
	
#	print("item_list.get_size()")
#	print(item_list.get_size())
	
	_item_list = item_list

	self.add_child(_item_list)

	add_labels(label_name_arg,labels_arg,space_for_labels)


func calculate_space_for_labels(label_name_arg:String, extra_labels_arg:Array) ->float:
	
	var space_for_labels:float = 0
	if label_name_arg != "":
		space_for_labels += _param_space_for_name
		
	space_for_labels += extra_labels_arg.size()*_param_space_for_extra_label
	
	return space_for_labels

func add_labels(label_name_arg:String, extra_labels_arg:Array,space_for_labels_arg:float) -> void:
	
	self.add_name_label(label_name_arg)
	
	var label_count = 0
	var this_item_list_pos=Vector2(0, 0 + space_for_labels_arg)
	for label in extra_labels_arg:
		var label_node:Label = Label.new()
		label_node.set_text(label)
		
		label_node.set_position(this_item_list_pos+Vector2(0,-label_count*self._param_space_for_extra_label))
		label_node.set_rotation(-PI/2);
		self.add_child(label_node)
		label_count += 1
		_combination_extra_labels.append(label_node)	

func update_labels(label_name_arg:String, extra_labels_arg:Array) -> void:
	
#	print ("child count in Combination item:" + str(self.get_child_count()))
	
	if _combination_name_label != null:
		self.remove_child(_combination_name_label)
		_combination_name_label.queue_free()
	for extra_label in _combination_extra_labels:
		extra_label.queue_free()
		self.remove_child(extra_label)
		
	_combination_extra_labels.clear()
	
#	print ("child count in Combination item After Removing:" + str(self.get_child_count()))
		
	var space_for_labels:float = calculate_space_for_labels(label_name_arg, extra_labels_arg)
#	self.add_name_label(label_name_arg)
	add_labels(label_name_arg, extra_labels_arg,space_for_labels)


func get_width() -> float:
	if _item_list:
		return _item_list.get_size().x
	return _fixed_icon_size.x*_scale

func get_combidict() -> Dictionary:
	return self._combination_dict

func get_combination()->Combination:
	var combination:Combination = Combination.new(_combination_dict)
	return combination	
#
func highlight(color_arg:Color) -> void:
	self._item_list.set_item_custom_bg_color(0,color_arg)
	_item_list.update() #necesario para que se repinte y se vea el cambio de color


func get_image_texture_fraction(texture_arg:Texture,height_max_arg:int) -> ImageTexture:
	var image : Image = texture_arg.get_data()
#	print("before")
#	print(image.get_size())
	image.lock()
	if height_max_arg < image.get_height():
		image.crop(image.get_width(),height_max_arg)
	image.unlock()
	var texture = ImageTexture.new()
	texture.create_from_image(image)
	
#	print("after")
#	print(image.get_size())
	
	return texture
