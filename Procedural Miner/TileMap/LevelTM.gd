extends TileMap

"""
current level is like a state -> switched by level classes 
	delegate update/procedural generations methods to the current level class
"""

onready var node_blocks_holder = GLOBAL.root.get_node("Blocks")
onready var block_factory = preload("res://Blocks/BlockFactory.tscn").instance()
# Node2D that designates where the level should start generating
onready var level_start = get_parent().get_node("BackgroundTM/TileSpawn")

# level classes
const DirtLevel = preload("res://TileMap/Levels/DirtLevel.gd")

var current_level = null
onready var start_pos = world_to_map( level_start.position )

# making sure first ground touched is depth 0 (not the air or anywhere else)
var first_grounded = false
# temp variable to get distance reached from prev ground to next touched ground
var player_prev_depth = 0
var player_depth = 0
# generate next level (margin) before level's max_height
var level_margin = 5
# generate next level after each y checkpoint
var depth_checkpoint = 0

func _ready():
	randomize()
	GLOBAL.player.connect("on_ground", self, "on_player_grounded")
	generate_level(DirtLevel, start_pos)
	
func generate_level(level_class, start_pos):
	current_level = level_class.new()
	current_level.init(self, block_factory, node_blocks_holder, start_pos)
	current_level.generate_surrounding_tiles()
	current_level.generate_block_vein()
	generate_structure(0, start_pos)
	depth_checkpoint += current_level.max_height
		
func generate_structure(STRUCTURE_TYPE, start_pos):
	print("Player: ", world_to_map(GLOBAL.player.position), " start_pos: ", start_pos)
	# load structure and get array of tile positions
	var structure = load("res://TileMap/Structures.tscn").instance().get_child(STRUCTURE_TYPE).duplicate()
	var cells = structure.get_used_cells()
	# get random position in current_level - level_margin
	var rand_pos = Vector2(round( rand_range(start_pos.x - current_level.max_width - level_margin, start_pos.x)), round( rand_range(start_pos.y, start_pos.y + current_level.max_height - level_margin)))
	# get distance required to translate structure cells to desired pos (rand_pos)
	var distance = Vector2(cells[0].x - rand_pos.x, cells[0].y - rand_pos.y)
	# loop through cells & replace cells with structure's cells
	for pos in cells:
		var translated = pos - distance
		set_cell(translated.x, translated.y, structure.get_cellv(pos))
		if translated.x == start_pos.x:
			for TILE in GLOBAL.Tiles:
				if structure.get_cellv(pos) == GLOBAL.Tiles[TILE]:
					set_cell(translated.x, translated.y, -1)
				
# update depth tracker when player falls to the ground
func on_player_grounded():
	player_depth += world_to_map(GLOBAL.player.ground_pos).y - player_prev_depth
	player_prev_depth = world_to_map(GLOBAL.player.ground_pos).y
	
	if not first_grounded: 
		first_grounded = true
		player_depth = 0
		
	# if player reaches end of current level depth
	# todo: fix this if statement (max_height should be added to previous level height)
	if player_depth >= depth_checkpoint - level_margin:
		level_start.position = current_level.last_pos + cell_size/2
		generate_level(DirtLevel, world_to_map(level_start.position))
#		populate_level_tiles(start_pos + Vector2(0, player_depth), level_index)
	
