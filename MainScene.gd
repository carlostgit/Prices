extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	#Todo: jugar con esto para encontrar trueques a distintos precios
	$PersonScene1.set_preference_for_candy()
	$PersonScene2.set_preference_for_chocolate()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
