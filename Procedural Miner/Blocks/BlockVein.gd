extends Area2D

export(int) var generate_amount = 15

onready var scn_block_factory = preload("res://Blocks/BlockFactory.tscn")

onready var block_holder = $BlockHolder
onready var factory = scn_block_factory.instance()

var current_block setget , get_front_block
var last_block setget , get_back_block

signal block_destroyed

# data provided by TileMap
var cell_size

func _ready():
	var spawn_pos = position
	for i in generate_amount:
		instance_block(factory.get_random_block(), spawn_pos)
		spawn_pos.y += cell_size.y
		pass
	pass
	
func on_block_destroyed(node_block):
	# instance a new block below last block
	var pos = block_holder.get_child(block_holder.get_child_count()-1).position
	pos = Vector2(pos.x, pos.y + cell_size.y)
	instance_block(factory.get_random_block(), pos)
	emit_signal("block_destroyed")

func instance_block(block, pos):
	block.connect("destroyed", self, "on_block_destroyed")
	block.position = pos
	block.add_to_group("Blocks")
	block_holder.add_child(block)
	
func get_front_block():
	return block_holder.get_child(0)
	
func get_back_block():
	return block_holder.get_child(block_holder.get_child_count()-1)
