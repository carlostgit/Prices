extends Control

const Combination = preload("res://Combination.gd")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(NodePath) var node_path1
export(NodePath) var node_path2

var _person1:Node = null
var _person2:Node = null

var _person1_trade_combidict = {}
var _person2_trade_combidict = {}
var _sum_of_trade_combidict = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	_person1 = get_node(node_path1)
	_person2 = get_node(node_path2)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func update_sum_trades()->void:
	var trade1_combination:Combination = Combination.new(_person1_trade_combidict)
	var trade2_combination:Combination = Combination.new(_person2_trade_combidict)
	
	trade1_combination.sum(trade2_combination)
	_sum_of_trade_combidict = trade1_combination.get_combidict()
	
	$SumOfAllTrades.set_text(str(_sum_of_trade_combidict))
	
	
func _on_PersonScene1_trade_updated(origin_node, trade_combidict):
	_person1_trade_combidict = trade_combidict
	$SumTradePerson1Label.set_text(str(trade_combidict))
	update_sum_trades()

func _on_PersonScene2_trade_updated(origin_node, trade_combidict):
	_person2_trade_combidict = trade_combidict
	$SumTradePerson2Label.set_text(str(trade_combidict))
	update_sum_trades()
