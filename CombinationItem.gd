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
var _products = ["chocolate","candy"]


var _scale:float = 0.5
var _fixed_icon_size:Vector2 = Vector2(50,50)

var _arguments:Array = []

var _combination_dict:Dictionary = Dictionary()

var _item_list:ItemList = null




# Called when the node enters the scene tree for the first time.
func _ready():
#	print ("ready!!")
#	init_default_test()
#
#	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	pass

func init_default_test():
#	var default_canvas_item = CanvasItem.new()
	var default_combidict = {"chocolate":1, "candy":2}
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
	
	#Dibujar una combinación, con la posibilidad de acompañarla de un valor
	add_item_list(combidict_arg, labels_arg)

	self.set_label(name_arg)

func _init(combidict_arg:Dictionary = Dictionary(), name_arg:String = "", labels_arg:Array = Array()):
##	_canvas_item = canvas_item_arg
#	_combination_dict = combidict_arg
#
#	#TODO
#	#Dibujar una combinación, con la posibilidad de acompañarla de un valor
#	add_item_list(combidict_arg, labels_arg)
#
#	self.set_label(name_arg)
	pass
	
func set_label(label_name_arg:String)->void:
#	print("label_name is")
	var label_name:Label = Label.new()
	label_name.set_scale(Vector2(1.5,1.5))
	label_name.set_text(label_name_arg)
	label_name.set("custom_colors/font_color", Color(1,0,0))
	#label_name.set_text("Pruebita")
	#print(self.get_name())
	label_name.set_position(self.get_position()+Vector2(0,0))

	self.add_child(label_name)
#
func add_item_list(combidict_arg:Dictionary, labels_arg:Array):

	for label in labels_arg:
		assert(typeof(label)==TYPE_STRING)

	var item_list:ItemList = ItemList.new()
	var num_item=0
	#var total_height = 0
	for product in combidict_arg.keys():
		var num_current_prod:float = combidict_arg[product]
		var num_int_current_prod:int = floor(num_current_prod)
		var partial_prod_amount = num_current_prod - num_int_current_prod

		var icon =null
		if(product == "chocolate"):
			icon = _chocolate
		elif (product == "candy"):
			icon = _candy
		else:
			icon = _dibujo_default
			assert(false)
			
		for pro in num_int_current_prod:
			#total_height += icon.get_size().y+6 
			item_list.add_icon_item(icon)
			#item_list.add_item("bla blaldjaf")
			num_item +=  1
			
		if partial_prod_amount>0:
#			item_list.add_item(str(partial_prod_amount))
#			if(product == "chocolate"):
#				icon = _part_chocolate
#			elif (product == "candy"):
#				icon = _part_candy
#			else:
#				icon = _dibujo_default
#				assert(false)
			
			var image : Image = icon.get_data()
			image.lock()
			for x in image.get_width():
				partial_prod_amount
				if partial_prod_amount > (float(x)/float(image.get_width())):
					for y in image.get_height():						
						image.set_pixel(x,y,Color(0,0,0,0))
			image.unlock()
			var texture = ImageTexture.new()
			texture.create_from_image(image)
			item_list.add_icon_item(texture)
			num_item += 1
			

	var parent_x_pos = self.get_position().x
	var parent_y_pos = self.get_position().y

	item_list.set_size(_fixed_icon_size*_scale)
	item_list.set_fixed_icon_size(_fixed_icon_size)
	var current_position_x = self.get_position().x+item_list.get_size().x
	var this_item_list_pos=Vector2(current_position_x,self.get_position().y+50)
	item_list.set_position(this_item_list_pos)
	item_list.set_auto_height(true)
	#item_list.set_fixed_column_width(_fixed_icon_size.x*0.3)
	item_list.set_icon_scale(_scale)
	_item_list = item_list

	self.add_child(_item_list)

	var label_count = 0
	for label in labels_arg:
		var label_node:Label = Label.new()
		label_node.set_text(label)
		label_node.set_position(this_item_list_pos+Vector2(0,-label_count*30))
		label_node.set_rotation(-PI/2);
		self.add_child(label_node)
		label_count += 1
	#self.draw_string(_font, this_item_list_pos,String(52),Color(1,1,1))

	pass
#
func get_width() -> float:
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

