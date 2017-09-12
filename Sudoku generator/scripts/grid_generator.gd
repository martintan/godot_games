extends Node2D

onready var scn_slot = preload("res://slot.tscn")
onready var sudoku_grid = get_node("../sudoku_grid")
var prev_pos = Vector2(0, 0)

func _ready():
	randomize()			# randomize the seed (true randomness)
	var grid = []
	init_grid(grid)	# 2d array for the grid (no clutter)
	# print_grid(grid)
	populate_grid(0, 0, grid)
	print_grid(grid)
	draw_grid(grid)
		
func init_grid(grid):
	for y in range(9):
		var row = []
		for x in range(9):
			row.append(0)
		grid.append(row)
#	grid[0][0] = 2

func populate_grid(y, x, grid):
	# loop until last index is valid or not empty
	
	while (!is_valid(8, 8, grid) or grid[8][8] == 0):
#		if (grid[y][x] != 0 and is_valid(y, x, grid)):
#			if (x == 8):
#				x = 0
#				y += 1
#			else: x += 1
#			populate_grid(y, x, grid)
		if (grid[y][x] < 9):
			grid[y][x] += 1
			if (is_valid(y, x, grid)):
				if (x == 8):
					x = 0
					y += 1
				else: x += 1
				populate_grid(y, x, grid)
		else: 
			grid[y][x] = 0
			break
	return grid
	
# check if the number is unique in (region, row, column)
func is_valid(y, x, grid):
	var candidate = grid[y][x]
	var start_x = x - (x%3)
	var start_y = y - (y%3)
	
	for i in range(9):
		if (grid[i][x] == candidate and i != y): return false
		if (grid[y][i] == candidate and i != x): return false
			
	for a in range(3):
		for b in range(3):
			if (grid[start_y + a][start_x + b] == candidate and start_y + a != y and start_x + b != x):
				return false

	return true

func draw_grid(grid):
	for child in sudoku_grid.get_children():
		child.queue_free()
	for y in range(9):
		for x in range(9):
			if (x % 3 == 0): prev_pos.x += 10
			var slot = scn_slot.instance()
			slot.set_pos(prev_pos)
			slot.set_number(str(grid[y][x]))
			sudoku_grid.add_child(slot)
			prev_pos.x += 74
		prev_pos.y += 74
		if ((y+1) % 3 == 0 and y != 0): prev_pos.y += 10
		prev_pos.x = 0

# helper functions	
func print_grid(grid):
	for y in range(9):
		for x in range(9):
			printraw(grid[y][x])
		printraw("\n")
