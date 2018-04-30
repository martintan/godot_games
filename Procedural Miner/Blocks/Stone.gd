extends Sprite

var break_type = 'SHOVEL'

func _ready():
	
	pass
	
func attempt_break(break_type):
	print('attempting ' + break_type + ' on ' + self.name)
	if break_type == self.break_type:
		print('correct')
		queue_free()
		pass
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


