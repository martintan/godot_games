extends Node2D

onready var scn_slot = preload("res://slot.tscn")
onready var grid = []
var width = 9
var height = 9

func _ready():
	randomize()					# randomize the seed (true randomness)
	instantiate_2d_array()	# 2d array for the grid (no clutter)
	print_2d_array()			# show in console (console help)
	populate_grid()			# main generation function
	print_2d_array()
		
func instantiate_2d_array():
	for row in range(height):
		grid.append([])					# array for each row
		var i = 0							
		for column in range(width):	# each cell will start with ZERO
			grid[row].append(i)
#			i += 1

func populate_grid():
	# access to each row of grid
	for row in grid:
		# access to each column of grid
		for column in row:
			# todo: move this to the top (better code..?)
			var number = round(rand_range(1, 10)) # number between 1-9
			var my_cell_index = row.find(column)  # get my cell's index for this row
			# keep trying until a number is valid for the cell
			while (!is_valid(number, grid, my_cell_index, row, column)): number = round(rand_range(1, 10))
			# finally insert the valid number
			grid[row][column] = number

# check if the number is unique within 3x3 box, row, and column of the grid
func is_valid(number, grid, cell_index, grid_row, grid_column):
	var valid = true
	for row in grid:
		# 1. check validity for current index of each ROW
		if (row[cell_index] == number): valid = false
		for column_number in row:
			# 2. check validity within COLUMN
			if (column_number == number): valid = false
	# 3. check validity within BOX
	# a. find out my row position in the grid
	var row_index = grid[grid.find(grid_row)]
	if (grid[row_index - 1] == null): # I am in the top row
		pass
	elif (grid[row_index + 1] == null): # I am in the bottom row
		
		pass
	else: # I am in the middle row
		var iter = 0						# check 3 times per row of the box
		var row_iter = row_index - 1	# start at the top row to the bottom row
		# TODO: CELL INDEX IS THE CURRENT INDEX BUT WE MUST START CHECKING FROM THE FIRST CELL
		var cell_iter = cell_index 	# index for the cell checkings
		# repeat this operation for 3 rows
		while (row_iter < row_index + 3):
			# check 3 cells of a row
			while (cell_iter < cell_index + 3):
				if (grid[row_index][cell_iter] == number): valid = false
				cell_iter += 1				# this should increment only 3 times (check 3 cells)
	return valid

# helper functions	
func print_2d_array():
	# print each row
	for y in grid: print(y)
