extends Node

onready var player setget , get_player
var root setget , get_scene_root

enum Tiles { DIRT, STONE, GRASS }
enum TilesBG { DIRT_CAVE_BG=3 }
enum Blocks { DIRT, STONE }

func get_player():
	return self.root.get_node("Player")
	
func get_scene_root():
	return get_tree().get_root().get_child(1)
