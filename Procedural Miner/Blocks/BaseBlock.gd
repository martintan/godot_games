extends StaticBody2D

var break_type
signal destroyed

func _init():
	pass

func _ready():
	pass
	
func destroy(break_type):
	if break_type == self.break_type:
#		print("Destroyed " + self.name)
		emit_signal("destroyed", self)
		queue_free()
		return true
	return false


