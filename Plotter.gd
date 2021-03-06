extends Control

var _max_x:float = 5 
var _max_y:float = 100

var _left_margin:float = 20
var _top_margin:float = 30
var _bottom_margin:float = 40
var _right_margin:float = 60

var _height:float = 500
var _width:float = 200

var _total_num_of_calculated_points:int = 100

#Parámetros que se calcularán a partir de los anteriores
var _x_zoom:float = 6
var _y_zoom:float = 40.0
var _calculated_points_per_unit:float = 0.0
#

var _canvas_item:CanvasItem = self
var _font = load("res://new_dynamicfont.tres")

var _func_array:Array = []
#var _label_array = []
var _func_label_dict:Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():

#	init(7,80)
#
#	var test_funcref = funcref( self, "default_test_function")
#	_func_array.append(test_funcref)
#	#_label_array.append("test")
#	_func_label_dict[test_funcref]="test"
	pass

func add_func_ref(func_ref_arg:FuncRef, label_arg:String = "")->void:
	_func_array.append(func_ref_arg)
	_func_label_dict[func_ref_arg]=label_arg

func default_test_function(x_arg:float) -> float:
	var y:float = x_arg*x_arg
	return y
#
#
#func _init(y_bottom_arg:float, x_left_arg:float, x_zoom_arg:float,y_zoom_arg:float,max_quantity_arg:float,num_of_calculated_points_arg:int, canvas_item_arg:CanvasItem):
#	init(y_bottom_arg,x_left_arg,x_zoom_arg,y_zoom_arg,max_quantity_arg,num_of_calculated_points_arg,canvas_item_arg)

func updated_size()->void:
	_canvas_item = self
	var param_min_width = 10
	_width = self.get_rect().size.x - _left_margin - _right_margin
	
	if _width < param_min_width:
		_width = param_min_width
	
	_x_zoom = _width/float(_total_num_of_calculated_points)
	
	var y_max:float = _max_y
	_height = self.get_rect().size.y - _top_margin - _bottom_margin
	var param_min_height = 10
	if _height < param_min_height:
		_height = param_min_height

	_y_zoom = _height/y_max
	
	_calculated_points_per_unit = float(_max_x)/float(_total_num_of_calculated_points)


func _init(x_max_arg:float=5, y_max_arg:float=10, left_margin_arg:float=40, right_margin_arg:float=40, top_margin_arg:float=40, bottom_margin_arg:float=40, points_calculated_arg=100):
	init(x_max_arg, y_max_arg, left_margin_arg, right_margin_arg, top_margin_arg, bottom_margin_arg, points_calculated_arg)

func init(x_max_arg:float, y_max_arg:float, left_margin_arg:float=40, right_margin_arg:float=40, top_margin_arg:float=40, bottom_margin_arg:float=40, points_calculated_arg=100):

	_max_x = x_max_arg 
	_max_y = y_max_arg
	_left_margin = left_margin_arg
	_right_margin = right_margin_arg
	_top_margin = top_margin_arg
	_bottom_margin = bottom_margin_arg
	_total_num_of_calculated_points = points_calculated_arg
	
	_canvas_item = self
	var param_min_width = 10
	_width = self.get_rect().size.x - _left_margin - _right_margin
	
	if _width < param_min_width:
		_width = param_min_width
	
	_x_zoom = _width/float(points_calculated_arg)
	
	var y_max:float = _max_y
	_height = self.get_rect().size.y - _top_margin - _bottom_margin
	var param_min_height = 10
	if _height < param_min_height:
		_height = param_min_height

	_y_zoom = _height/y_max
	
	_calculated_points_per_unit = float(_max_x)/float(_total_num_of_calculated_points)

#	var test_funcref = funcref( self, "default_test_function")
#	_func_array.append(test_funcref)
#	_label_array.append("test")
		

#func init_old(y_bottom_arg:float, x_left_arg:float, x_zoom_arg:float,y_zoom_arg:float,max_quantity_arg:float,num_of_calculated_points_arg:int, canvas_item_arg:CanvasItem):
#	_height=y_bottom_arg-_top_margin
#	_left_margin=x_left_arg
#
#	_x_zoom=x_zoom_arg
#	_y_zoom=y_zoom_arg
#
#	_max_x = max_quantity_arg
#
#	_total_num_of_calculated_points = num_of_calculated_points_arg
#	_canvas_item = canvas_item_arg
#
#	_calculated_points_per_unit = float(_max_x)/float(_total_num_of_calculated_points)

func _draw():
	draw_background()

	#Se dibujan todos las funciones que hay en _func_array
	#Esas funciones pueden estar en objetos que pueden desaparecer sin aviso
	#Por eso uso el método FuncRef::is_valid()
	
	var count:int = 0
	var index_of_not_valid_func:int = -1
	var not_valid_func
	for func_to_draw in _func_array:
		var label:String = self._func_label_dict[func_to_draw]
		if func_to_draw.is_valid():
			draw(func_to_draw,label)
		else:
			index_of_not_valid_func=count
			not_valid_func = func_to_draw
		count +=1
	
	if index_of_not_valid_func >=0:
		_func_label_dict.erase(not_valid_func)
		_func_array.remove(index_of_not_valid_func)

func draw_background():
	
	#Bordes del Control:
	var rect_width:float = self.get_rect().size.x
	var rect_height:float = self.get_rect().size.y
	_canvas_item.draw_line(Vector2(0,rect_height),Vector2(rect_width,rect_height), Color(0,1,1))
	_canvas_item.draw_line(Vector2(0,0),Vector2(rect_width,0), Color(0,1,1))
	_canvas_item.draw_line(Vector2(0,0),Vector2(0,rect_height), Color(0,1,1))
	_canvas_item.draw_line(Vector2(rect_width,0),Vector2(rect_width,rect_height), Color(0,1,1))
	#
	#Márgenes
	_canvas_item.draw_line(Vector2(_left_margin,rect_height-_bottom_margin),Vector2(rect_width-_right_margin,rect_height-_bottom_margin), Color(1,0,1))
	_canvas_item.draw_line(Vector2(_left_margin,_top_margin),Vector2(rect_width-_right_margin,_top_margin), Color(1,0,1))
	_canvas_item.draw_line(Vector2(_left_margin,_top_margin),Vector2(_left_margin,rect_height-_bottom_margin), Color(1,0,1))
	_canvas_item.draw_line(Vector2(rect_width-_right_margin,_top_margin),Vector2(rect_width-_right_margin,rect_height-_bottom_margin), Color(1,0,1))
	#
	
	#Línea y
	_canvas_item.draw_line(Vector2(_left_margin,_height+_top_margin),Vector2(_width+_left_margin,_height+_top_margin), Color(1,1,1))

	#Dibujo la linea del y=1
#	_canvas_item.draw_line(Vector2(_left_margin,_height+_top_margin-1*_y_zoom),Vector2(_width+_left_margin,_height+_top_margin-1*_y_zoom), Color(1,1,1)) #Value of 1 line

	#Línea x
	_canvas_item.draw_line(Vector2(_total_num_of_calculated_points*_x_zoom+_left_margin,_height+_top_margin),Vector2(_total_num_of_calculated_points*_x_zoom+_left_margin,_top_margin), Color(1,1,1)) #Cuantity of 100 line

	#10 líneas verticales
	for line in range(1,10):
		_canvas_item.draw_line(Vector2((line*_total_num_of_calculated_points/10)*_x_zoom+_left_margin,_height+_top_margin),Vector2((line*_total_num_of_calculated_points/10)*_x_zoom+_left_margin,_top_margin), Color(1,1,1)) #Cuantity of 50 line

	var font_size_y:float = _font.get_string_size("0").y
	
	#_max_x Etiqueta con el máximo en X
	_canvas_item.draw_string(_font,Vector2(_total_num_of_calculated_points*_x_zoom+_left_margin,_height+_top_margin+font_size_y),String(_max_x),Color(1,1,1))
	
	#Etiqueta con el mínimo en x
	_canvas_item.draw_string(_font,Vector2(_left_margin,_height+_top_margin+font_size_y),String("0"),Color(1,1,1))
	
	#Dibujo la etiqueta del y=1
	#_canvas_item.draw_string(_font,Vector2(0,_height+_top_margin-1*_y_zoom),"1",Color(1,1,1))

	#_max_y Etiqueta con el máximo en Y
	_canvas_item.draw_string(_font,Vector2(0,_top_margin),str(_max_y),Color(1,1,1))
	
	#Etiqueta con el mínimo en y
	_canvas_item.draw_string(_font,Vector2(0,_height+_top_margin),String("0"),Color(1,1,1))


func draw(var myfunc, var label_arg:String, color_arg:Color = Color(0,1,0)):

	var last_y:float = 0
	var last_x:float = 0
	for i in range(0,_total_num_of_calculated_points):	

		var x1:float = _x_zoom*float(i)
		var x2:float = _x_zoom*float(i+1)
#		var y1:float = _y_zoom*myfunc.call_func(func_arg,i*_calculated_points_per_unit)
#		var y2:float = _y_zoom*myfunc.call_func(func_arg,(i+1)*_calculated_points_per_unit)
		var y1:float = _y_zoom*myfunc.call_func(i*_calculated_points_per_unit)
		var y2:float = _y_zoom*myfunc.call_func((i+1)*_calculated_points_per_unit)
	
		_canvas_item.draw_line(Vector2((_left_margin+x1),_height+_top_margin-y1), Vector2((_left_margin+x2), _height+_top_margin-y2), color_arg, 1)

		last_x = _left_margin+x2
		last_y = _height+_top_margin-y2
		
	_canvas_item.draw_string(_font,Vector2(last_x, last_y),label_arg,color_arg)
