extends Node

onready var player setget , get_player

enum Tiles { DIRT, STONE, GRASS }

func get_player():
	return get_tree().get_root().get_child(1).get_node("Player")
