extends Node2D

func _ready():
	pass
	
func set_number(number):
	get_node("label_number").set_text(number)