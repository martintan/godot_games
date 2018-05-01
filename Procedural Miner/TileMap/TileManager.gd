extends TileMap

export var procedural_spawn_size = Vector2(10, 10)
# maximum width of tiles when generating a new row of tiles (whenever player breaks a block)
export var max_row_width = 10

onready var tile_spawn_pos = $TileSpawn.position
onready var scn_block_vein = preload("res://Blocks/BlockVein.tscn")
onready var node_blocks = get_node("../Blocks")
onready var main_camera = $Player/MainCamera

# reference to current block vein
var current_vein

# edge where tiles stop spawning
var tiles_edge
var edge_padding = 2

enum Tiles { DIRT }

func _ready():
	# clear cells from (start_pos) down to (spawn size)
	var start_pos = world_to_map(tile_spawn_pos)
	var end = start_pos + procedural_spawn_size
	for i in range(start_pos.y, end.y):
		set_cell(start_pos.x, i, -1)
#		generate_block(block_factory.get_random_block(), map_to_world(Vector2(start_pos.x, i)) )	
	tiles_edge = map_to_world(end)

	var block_vein = scn_block_vein.instance()
	block_vein.position = map_to_world(start_pos)
	block_vein.cell_size = cell_size
	block_vein.connect("block_destroyed", self, "on_vein_block_destroyed")
	node_blocks.add_child(block_vein)
	
	current_vein = block_vein
	
# signal is called after a new block is instanced (new empty row)
func on_vein_block_destroyed():
	# generate new row of tiles on row of last block position
	var cell = Vector2(cell_size.x, 0)
	var pos_left = current_vein.last_block.position - cell
	var pos_right = current_vein.last_block.position + cell
	for i in max_row_width:
		if get_cellv(world_to_map(Vector2(pos_left.x, pos_left.y - cell_size.y))) != -1:
			set_cellv(world_to_map(pos_left), Tiles.DIRT)
			pos_left -= cell
		if get_cellv(world_to_map(Vector2(pos_right.x, pos_right.y - cell_size.y))) != -1:
			set_cellv(world_to_map(pos_right), Tiles.DIRT)
			pos_right += cell
	
func _process(delta):
	pass
