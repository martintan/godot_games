extends KinematicBody2D

export(float) var gravity = 9.8
export(int) var gravity_modifier = 10

const floor_normal = Vector2(0, -1)

onready var tools = $Tools
onready var ground_check = $GroundDetection
onready var anim_player = $AnimationPlayer

var velocity = Vector2()
var ground_pos setget, get_ground_pos

# small queue for fast block breaking
var blocks_in_range = []

signal on_ground

func _ready():
	anim_player.play("idle")
	pass
	
func _process(delta):
#	print(velocity)
	if Input.is_action_just_pressed("tool_1"):
		destroy_block(tools.get_child(0))
		anim_player.play("pickaxe_swing_fast", -1, 2)
		
	elif Input.is_action_just_pressed("tool_2"):
		destroy_block(tools.get_child(1))
		
	elif Input.is_action_just_pressed("tool_3"):
		destroy_block(tools.get_child(2))
	
func destroy_block(node_tool):
	if blocks_in_range.size() <= 0: return
	var block = blocks_in_range[0]
	if block.destroy(node_tool.name):
		blocks_in_range.pop_front()
	
func _physics_process(delta):
	velocity.y += gravity * gravity_modifier
	if is_on_floor():
		velocity.y = 0
	move_and_slide(velocity, floor_normal)

# signal from $GroundDetection
func _on_GroundDetection_body_entered(body):
	if not body is KinematicBody2D:
		if body.is_in_group("Blocks"):
			blocks_in_range.push_back(body)
		emit_signal("on_ground")
		
# getter for property ground_pos
func get_ground_pos():
	return ground_check.global_position