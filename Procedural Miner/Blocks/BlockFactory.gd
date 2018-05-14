extends Node

export var block_queue_size = 5

func _ready():
	randomize()
#	for block in get_children():
#		block.visible = false
	pass
	
func get_random_block():
	return get_child( floor(rand_range(0, get_child_count()-1)) ).duplicate()
	
func get_block(BLOCK_TYPE):
	return get_child(BLOCK_TYPE).duplicate()
	
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
