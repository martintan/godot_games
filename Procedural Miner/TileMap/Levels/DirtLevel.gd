extends "res://TileMap/Levels/BaseLevel.gd"

var block_types = [ GLOBAL.Blocks.DIRT, GLOBAL.Blocks.STONE ]

func level_init():
	self.max_height = 20
	self.max_width = 20
	self.MAIN_BLOCK_TYPE = GLOBAL.Tiles.DIRT
	self.last_pos = tilemap.map_to_world(Vector2(start_pos.x, start_pos.y + max_height))
	
# generate the entire vein (appropriate) tile in the background
func generate_surrounding_tiles():
	.generate_surrounding_tiles()
	# generate (max_height) rows of bg tiles
	for y in range(start_pos.y, start_pos.y + max_height):
		# populate leftmost to rightmost with bg tiles
		for x in range(start_pos.x - max_width, start_pos.x + max_width + 1):
			tilemap.set_cell(x, y, self.MAIN_BLOCK_TYPE)
	
# generate the entire block vein for this level
func generate_block_vein():
	.generate_block_vein()
	# todo: remove need for this code by -> checking if in spawn_column inside generate_surrounding_tiles()
	# clear cells from (start_pos) down to (max_height)
	for y in range(start_pos.y, start_pos.y + max_height):
		tilemap.set_cell(start_pos.x, y, -1)
		# after clearing, generate random block from list of blocks
		var RANDOM_BLOCK_TYPE = block_types[ round( rand_range(0, block_types.size()-1) ) ]
		instance_block(RANDOM_BLOCK_TYPE, map_to_world(Vector2(start_pos.x, y)))

# signal: block is destroyed by player
func on_block_destroyed(node_block):
	.on_block_destroyed(node_block)
	