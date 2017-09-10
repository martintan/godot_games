extends Node2D

onready var scn_slot = preload("res://slot.tscn")
onready var grid = []
var width = 9
var height = 9

func _ready():
	randomize()					# randomize the seed (true randomness)
	instantiate_2d_array()	# 2d array for the grid (no clutter)
	#print_2d_array()			# show in console (console help)
	populate_grid()			# main generation function
	print_2d_array()
		
func instantiate_2d_array():
	for row in range(height):
		grid.append([])																	# array for each region (box/region)
		for column in range(width): grid[row].append(0)							# non-populated cells = 0		
			

func populate_grid():
	for region in range(grid.size()): 												# access to each region of grid
		for cell in range(grid[region].size()): 									# access to each cell of region
			var number
			while (true):																	# keep trying until a number is valid for the cell
				number = round(rand_range(1, 9))										# random number from [1, 9]
				if (is_valid(number, cell, region, grid)): break
			grid[region][cell] = number												# finally insert the valid number
			print_2d_array()
	print("finished")

# check if the number is unique in (region, row, column)
func is_valid(number, cell, region, grid):
	
	# check uniqueness in region
	for n in grid[region]: if (n == number): return false
	
	# 1. check uniqueness in row
	var first_region = region % 3
	for i in range(first_region, first_region + 3):
		var first_cell = cell % 3
		for j in range(first_cell, first_cell + 3):
			if (grid[i][j] == number): return false
			
	# 2. check uniqueness in column
#	region_pos = region_pos % 3														# 5 % 3 = 2, 2 is 1st index of a column
#	for a in range(region_pos, region_pos + 6, 3):
#		cell_pos = cell_pos % 3
#		for b in range(cell_pos, cell_pos + 6, 3):
#			if (b == number): return false
	return true

# helper functions	
func print_2d_array():	
	print("=================")
	for region in range(grid.size()):
		var arr = []
		for cell in range(grid[region].size()):
			arr.append(grid[region][cell])
			if (arr.size() >= 3):
				printraw(arr)
				printraw("\n")
				arr.clear()
		printraw("\n")
