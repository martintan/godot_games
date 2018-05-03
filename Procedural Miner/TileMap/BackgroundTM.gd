extends TileMap

"""
todo:
	setup level classes
	block vein generate amount is provided by the level class size
	don't generate new block every break (because the next level can have new block types)
		instead generate new (generate_amount=15) blocks when next level is being populated
"""

onready var tile_spawn_pos = $TileSpawn.position
#onready var node_blocks = get_node("../Blocks")
#onready var main_camera = $Player/MainCamera

enum Tiles { DIRT }

func _ready():
	pass
