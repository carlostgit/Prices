extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var _trade_combidict = {}
#var _trade_out_combidict = {}
#var _trade_in_combidict = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func set_trade_combidict(trade_combidict_arg:Dictionary)->void:
	_trade_combidict = trade_combidict_arg
