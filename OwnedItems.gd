extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var _max_limit = 5

var _num_candy:int = 0
var _num_chocolate:int = 0

signal signal_owned_candy_changed(num)
signal signal_owned_chocolate_changed(num)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_num_candy()->int:
	return _num_candy
	
func get_num_chocolate()->int:
	return _num_chocolate

func set_num_candy(num:int):
	_num_candy = num
	$LabelOwnedCandy.set_text(str(_num_candy))
	
func set_num_chocolate(num:int):
	_num_chocolate = num
	$LabelOwnedChocolate.set_text(str(_num_chocolate))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ButtonCandyPlus_pressed():
	if _num_candy<_max_limit:
		_num_candy += 1
		$LabelOwnedCandy.set_text(str(_num_candy))
		emit_signal("signal_owned_candy_changed",_num_candy)

func _on_ButtonCandyMinus_pressed():
	if _num_candy>0:
		_num_candy -= 1
		$LabelOwnedCandy.set_text(str(_num_candy))
		emit_signal("signal_owned_candy_changed",_num_candy)
	
func _on_ButtonChocolatePlus_pressed():
	if _num_chocolate<_max_limit:
		_num_chocolate += 1
		$LabelOwnedChocolate.set_text(str(_num_chocolate))
		emit_signal("signal_owned_chocolate_changed",_num_chocolate)

func _on_ButtonChocolateMinus_pressed():
	if _num_chocolate>0:
		_num_chocolate -= 1
		$LabelOwnedChocolate.set_text(str(_num_chocolate))
		emit_signal("signal_owned_chocolate_changed",_num_chocolate)

