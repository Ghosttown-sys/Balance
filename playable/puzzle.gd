class_name Puzzle_Handler
extends Node

const GRID = preload("res://playable/Grid.tscn")

@onready var problem_puzzle: GridContainer = %problem_puzzle
@onready var puzzle_generator: PUZZLE_GENERATOR = %puzzle_generator

var puzzle := {}
var user_values := []  

signal puzzle_completed

#region Initialization and Setup
	
func set_puzzle(level : int , difficulty: float):
	clear_puzzle()
	puzzle = puzzle_generator.generate_puzzle(level, difficulty)
	user_values.resize(6)
	for y in range(6):
		user_values[y] = []
		for x in range(6):
			var value = puzzle["puzzle"][y][x]
			user_values[y].append(value)

			var cell_problem = GRID.instantiate()
			cell_problem.set_grid(value)
			problem_puzzle.add_child(cell_problem)

			var cell_x := x
			var cell_y := y
			cell_problem.value_changed.connect(func(new_value: int):
				update_value(cell_x, cell_y, new_value)
			)
#endregion

#region Value Update and Checks
func update_value(x: int, y: int, new_value: int) -> void:
	user_values[y][x] = new_value

	if !is_valid_row_or_col(x, y):
		highlight_row_and_col(x, y)
		return

	if is_consecutive_error(x, y):
		highlight_row_and_col(x, y)
		return

	clear_row_and_col(x, y)
	check_for_win()

#endregion

#region Row/Column Validation
func is_valid_row_or_col(x: int, y: int) -> bool:
	var row_ones = 0
	var row_zeros = 0
	var col_ones = 0
	var col_zeros = 0

	for i in range(6):
		if user_values[y][i] == 1:
			row_ones += 1
		elif user_values[y][i] == 0:
			row_zeros += 1
	for i in range(6):
		if user_values[i][x] == 1:
			col_ones += 1
		elif user_values[i][x] == 0:
			col_zeros += 1

	return row_ones <= 3 and row_zeros <= 3 and col_ones <= 3 and col_zeros <= 3
#endregion

#region Consecutive Value Check
func is_consecutive_error(x: int, y: int) -> bool:
	var consecutive_ones = 0
	var consecutive_zeros = 0

	# Check row
	for i in range(6):
		match user_values[y][i]:
			1:
				consecutive_ones += 1
				consecutive_zeros = 0
			0:
				consecutive_zeros += 1
				consecutive_ones = 0
			_:
				consecutive_ones = 0
				consecutive_zeros = 0
		if consecutive_ones == 3 or consecutive_zeros == 3:
			return true

	consecutive_ones = 0
	consecutive_zeros = 0
	# Check column
	for i in range(6):
		match user_values[i][x]:
			1:
				consecutive_ones += 1
				consecutive_zeros = 0
			0:
				consecutive_zeros += 1
				consecutive_ones = 0
			_:
				consecutive_ones = 0
				consecutive_zeros = 0
		if consecutive_ones == 3 or consecutive_zeros == 3:
			return true

	return false
#endregion


#region Grid Delegation for Color
func highlight_row_and_col(x: int, y: int) -> void:
	for i in range(6):
		problem_puzzle.get_child(y * 6 + i).show_error(true)
		problem_puzzle.get_child(i * 6 + x).show_error(true)

func clear_row_and_col(x: int, y: int) -> void:
	for i in range(6):
		problem_puzzle.get_child(y * 6 + i).show_error(false)
		problem_puzzle.get_child(i * 6 + x).show_error(false)
#endregion

func check_for_win() -> void:
	for y in range(6):
		for x in range(6):
			var val = user_values[y][x]
			if val == -1:
				return  # Incomplete
			if !is_valid_row_or_col(x, y):
				return  # Invalid
			if is_consecutive_error(x, y):
				return  # Error
	lock_all_cells()

func lock_all_cells() -> void:
	puzzle_completed.emit()
	for cell in problem_puzzle.get_children():
		cell.lock()

func clear_puzzle() -> void:
	for child in problem_puzzle.get_children():
		child.queue_free()
	user_values.clear()
