extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const _products = ["chocolate","candy"]
const _empty_combidict = {"chocolate": 0, "candy": 0}
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func sort_combdict(combdict_arg:Dictionary)->void:
	#En los diccionarios se mantiene el orden en el que se añaden los elementos
	var combdict_copy:Dictionary = combdict_arg.duplicate()
	#Borro lo que había, y lo vuelvo a añadir en el orden correcto
	combdict_arg.clear()
	for prod in _products:
		if (combdict_copy.has(prod)):
			combdict_arg[prod]=combdict_copy[prod]
		else:
			combdict_arg[prod]=0


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
