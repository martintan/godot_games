extends TileMap

export var procedural_spawn_size = Vector2(10, 10)

onready var start_pos = $TileSpawn.position

func _ready():
	print(world_to_map(start_pos))
	
	# clear cells from (start_pos) down to (spawn size)
	var start = world_to_map(start_pos)
	var end = start + procedural_spawn_size
	for i in range(start.y, end.y):
		set_cell(start.x, i, -1)
		
	
	

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
