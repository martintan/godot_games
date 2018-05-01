extends KinematicBody2D

export(float) var gravity = 9.8
export(int) var gravity_modifier = 10

const floor_normal = Vector2(0, -1)

onready var tools = $Tools

var velocity = Vector2()
# current engaged block vein
var vein

func _ready():
	pass
	
func _process(delta):
#	print(velocity)
	if Input.is_action_just_pressed("tool_1"):
		destroy_block(vein.current_block, tools.get_child(0))
	elif Input.is_action_just_pressed("tool_2"):
		destroy_block(vein.current_block, tools.get_child(1))
	elif Input.is_action_just_pressed("tool_3"):
		destroy_block(vein.current_block, tools.get_child(2))
	
func destroy_block(node_block, node_tool):
	if node_block != null and node_tool != null:
		node_block.destroy(node_tool.name)
	
func _physics_process(delta):
	velocity.y += gravity * gravity_modifier
	if is_on_floor():
		velocity.y = 0
	move_and_slide(velocity, floor_normal)


func _on_VeinDetection_area_entered(area):
	vein = area

func _on_VeinDetection_body_entered(body):
	pass # replace with function body
