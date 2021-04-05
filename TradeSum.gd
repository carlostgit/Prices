extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(NodePath) var node_path1
export(NodePath) var node_path2

var _person1:Node = null
var _person2:Node = null

# Called when the node enters the scene tree for the first time.
func _ready():
	_person1 = get_node(node_path1)
	_person2 = get_node(node_path2)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_PersonScene1_trade_updated(origin_node, trade_combidict):
	$SumTradePerson1Label.set_text(str(trade_combidict))
	pass # Replace with function body.


func _on_PersonScene2_trade_updated(origin_node, trade_combidict):
	$SumTradePerson2Label.set_text(str(trade_combidict))
	pass # Replace with function body.
