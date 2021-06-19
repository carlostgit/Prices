extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal signal_num_persons_updated(num)

var _person_scene_res = preload("res://PersonScene.tscn")

var _person_scene_instances = []


# Called when the node enters the scene tree for the first time.
func _ready():
	#Todo: jugar con esto para encontrar trueques a distintos precios
#	$PersonScene1.set_preference_for_candy()
#	$PersonScene2.set_preference_for_candy()

	add_person_scene_instance()
	add_person_scene_instance()
	
	pass # Replace with function body.

func add_person_scene_instance():
#	Prueba instancia
	var instance = _person_scene_res.instance()
	add_child(instance)
	instance.set_preference_for_chocolate()
	var position_y = 0 + 200*_person_scene_instances.size()
	instance.set_position(Vector2(0,position_y))
	instance.connect("trade_updated",$CanvasLayer/TradeSum,"_on_PersonScene_trade_updated")
	$PricesInfo.connect("prices_changed",instance,"_on_PricesInfo_prices_changed")
	_person_scene_instances.append(instance)
	emit_signal("signal_num_persons_updated",_person_scene_instances.size())
#
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
