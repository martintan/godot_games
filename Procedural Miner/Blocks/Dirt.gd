# Dirt
extends "res://Blocks/BaseBlock.gd"


func _ready():
	._ready()
	break_type = "SHOVEL"
	
func destroy(break_type):
	return .destroy(break_type)

