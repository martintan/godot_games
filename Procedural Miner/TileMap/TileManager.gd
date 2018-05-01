extends TileMap

"""
todo:
	setup level classes
	block vein generate amount is provided by the level class size
	don't generate new block every break (because the next level can have new block types)
		instead generate new (generate_amount=15) blocks when next level is being populated

"""

export var procedural_spawn_size = Vector2(10, 10)
# maximum width of tiles when generating a new row of tiles (whenever player breaks a block)
export var max_row_width = 10

onready var tile_spawn_pos = $TileSpawn.position
onready var scn_block_vein = preload("res://Blocks/BlockVein.tscn")
onready var node_blocks = get_node("../Blocks")
onready var main_camera = $Player/MainCamera

# Underground levels and amount of tiles before it moves to next level
# todo: replace this with classes of Level (has info like height, name)
var levels = [ "DIRT", "STONE" ]
var level_heights = {
	"DIRT": 15,
	"STONE": 15,	
}

var start_pos
# reference to current block vein
var current_vein

# track player depth
var first_grounded = false
var player_prev_depth = 0
var player_depth = 0
# depth level tracking
var level_index = 0
var current_level = levels[0] setget , get_current_level

enum Tiles { DIRT }

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
	
func populate_level_tiles(start, TILE):
	
	# populate first level with appropriate tiles
	for y in range(start.y, start.y + level_heights[current_level]):
		# populate (row_width=10) left and (row_width=10) right + (1) middle 
		for x in range(start.x - max_row_width, start.x + max_row_width):
			# todo: replace cell index with index provided by current level class
			set_cell(x, y, TILE)
			
	# clear cells from (start_pos) down to (spawn size)
	for y in range(start.y, start.y + level_heights[current_level]):
		set_cell(start.x, y, -1)
	
# signal is called after a new block is instanced (new empty row)
func on_vein_block_destroyed():
	return
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
#	player_prev_depth = world_to_map(GLOBAL.player.position).y
	
# update depth tracker when player falls to the ground
func on_player_grounded():
	player_depth += world_to_map(GLOBAL.player.depth).y - player_prev_depth
	player_prev_depth = world_to_map(GLOBAL.player.depth).y
	
	if not first_grounded: 
		first_grounded = true
		player_depth = 0
		
	if level_index+1 < levels.size() and player_depth >= level_heights[current_level]:
		print("idx: ", level_index, "levels array: ", levels.size())
		level_index += 1
		populate_level_tiles(start_pos + Vector2(0, player_depth), level_index)
#	print(player_depth)
	
func _process(delta):
	pass
	
func get_current_level():
	return levels[level_index]
