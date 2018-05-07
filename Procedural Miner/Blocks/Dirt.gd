# Dirt
extends "res://Blocks/BaseBlock.gd"


func _ready():
	._ready()
	break_type = "PICKAXE"
	
func destroy(break_type):
	return .destroy(break_type)

