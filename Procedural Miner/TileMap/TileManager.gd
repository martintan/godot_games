extends TileMap

export var procedural_spawn_size = Vector2(10, 10)

onready var start_pos = $TileSpawn.position
onready var blocks_holder = get_parent().get_node("Blocks")

var block_factory
# queue structure for block nodes
# push front, pop back
var block_queue = []

func _ready():
	randomize()
	block_factory = preload("res://Blocks/BlockFactory.tscn").instance()
	
	# clear cells from (start_pos) down to (spawn size)
	var start = world_to_map(start_pos)
	var end = start + procedural_spawn_size
	for i in range(start.y, end.y):
		set_cell(start.x, i, -1)
		var block = block_factory.get_random_block()
		block.position = map_to_world(Vector2(start.x, i)) + cell_size/2
		blocks_holder.add_child(block)
		block_queue.push_front(block)
	

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
