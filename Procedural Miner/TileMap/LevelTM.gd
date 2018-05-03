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
var level_margin = 3

func _ready():
	GLOBAL.player.connect("on_ground", self, "on_player_grounded")
	generate_level(DirtLevel, start_pos)
	
func generate_level(level_class, start_pos):
	current_level = level_class.new()
	current_level.init(self, block_factory, node_blocks_holder, start_pos)
	current_level.generate_surrounding_tiles()
	current_level.generate_block_vein()
		
# update depth tracker when player falls to the ground
func on_player_grounded():
	player_depth += world_to_map(GLOBAL.player.depth).y - player_prev_depth
	player_prev_depth = world_to_map(GLOBAL.player.depth).y
	
	if not first_grounded: 
		first_grounded = true
		player_depth = 0
		
	# if player reaches end of current level depth
	# todo: fix this if statement (max_height should be added to previous level height)
	if player_depth >= current_level.max_height - level_margin:
		level_start.position = current_level.last_pos + cell_size/2
		generate_level(DirtLevel, world_to_map(level_start.position))
#		populate_level_tiles(start_pos + Vector2(0, player_depth), level_index)
	
