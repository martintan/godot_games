extends Node

export var block_queue_size = 5
# queue structure for blocks
# push front, pop back
var block_queue = []


func _ready():
	randomize()
	for i in block_queue_size:
		block_queue.push_front( get_random_block() )
	
func get_random_block():
	return get_child(rand_range(0, get_child_count())).duplicate()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
