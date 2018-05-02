extends Node

# child index of current_level
var level_index
# child reference to current_level
var current_level setget set_current_level, get_current_level

func _ready():
	GLOBAL.player.connect("on_ground", self, "on_player_grounded")
	
	start_pos = world_to_map(tile_spawn_pos)
	populate_level_tiles(start_pos, Tiles.DIRT)
#		generate_block(block_factory.get_random_block(), map_to_world(Vector2(start_pos.x, i)) )	

	var block_vein = scn_block_vein.instance()
	block_vein.position = map_to_world(start_pos)
	block_vein.cell_size = cell_size
	block_vein.connect("block_destroyed", self, "on_vein_block_destroyed")
	node_blocks.add_child(block_vein)
	
	current_vein = block_vein
	
func set_current_level(value):
	level_index = value if value < get_child_count() else null

func get_current_level():
	return get_child(level_index)
