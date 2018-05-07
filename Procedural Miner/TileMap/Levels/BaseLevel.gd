extends TileMap

# block types the level wants to use
var MAIN_BLOCK_TYPE

# needed reference to TileMap (LevelTM) -> for generating tiles
var tilemap
# needed reference to BlockFactory -> for getting block nodes
var factory
# needed reference to Blocks (Node) -> stores all instanced blocks
var node_blocks_holder
# position to start -> search left&right -> generate surrounding tiles
var start_pos

# maximum height of this level (default=15)
var max_height = 15
# maximum left&right width of surrounding tiles
var max_width = 10

# track player depth
var player_depth = 0
# store last block position in map coordinates
var last_pos
# store references to each block in list
var block_vein = []

# base init for assigning necessary references & other info
func init(tilemap, factory, node_blocks_holder, start_pos):
	self.tilemap = tilemap
	self.cell_size = tilemap.cell_size
	self.factory = factory
	self.start_pos = start_pos
	self.node_blocks_holder = node_blocks_holder
	level_init()
	
# virtual init for child classes to assign info about the level
func level_init():
	# default implementation
	pass
	
# generate the entire vein (appropriate) tile in the background
func generate_surrounding_tiles():
	# default implementation
	pass
	
# generate the entire block vein for this level
func generate_block_vein():
	# default implementation
	pass

# instance_block( enum BLOCK_TYPE, Vector2 spawn_pos)
func instance_block(BLOCK_TYPE, spawn_pos):
	var block = self.factory.get_block(BLOCK_TYPE)
	block.position = spawn_pos
	block.connect("destroyed", self, "on_block_destroyed")
	block.add_to_group("Blocks")
	node_blocks_holder.add_child(block)
	block_vein.push_back(block)

# signal: block is destroyed by player
func on_block_destroyed(node_block):
	# default implementation
	pass