class_name Puzzle_Handler
extends Node

const GRID = preload("res://playable/grid/Grid.tscn")

@onready var problem_puzzle: GridContainer = %problem_puzzle
@onready var puzzle_generator: PUZZLE_GENERATOR = %puzzle_generator

var puzzle := {}
var user_values := []
var undo_stack: Array = []
var redo_stack: Array = []
signal puzzle_completed

#region Initialization and Setup
func set_puzzle(level: int, difficulty: float, complexcity: int):
	clear_puzzle()
	puzzle = puzzle_generator.generate_puzzle(level, difficulty, complexcity)
	user_values.resize(6)

	for y in range(6):
		user_values[y] = []
		for x in range(6):
			var value = puzzle["puzzle"][y][x]
			var valid_input = puzzle["valid_inputs"]
			user_values[y].append(value)

			var cell_problem = GRID.instantiate()
			cell_problem.set_grid(value, valid_input)
			problem_puzzle.add_child(cell_problem)

			var cell_x := x
			var cell_y := y
			cell_problem.value_changed.connect(func(new_value: int):
				update_value(cell_x, cell_y, new_value)
			)
#endregion

#region Value Update and Checks
func update_value(x: int, y: int, new_value: int) -> void:
	var old_value = user_values[y][x]
	if old_value == new_value:
		return

	# Record move
	undo_stack.append({ "x": x, "y": y, "old": old_value, "new": new_value })
	if undo_stack.size() > 100:
		undo_stack.pop_front()
	redo_stack.clear()

	user_values[y][x] = new_value
	highlight_row_and_col(x, y)

	var cell = problem_puzzle.get_child(y * 6 + x)
	cell.set_input_value(new_value)

	if is_row_valid(y) and is_col_valid(x):
		check_for_win()
#endregion

#region Undo / Redo
func undo():
	if undo_stack.is_empty():
		return

	var move = undo_stack.pop_back()
	var x = move["x"]
	var y = move["y"]
	var old_value = move["old"]
	var new_value = user_values[y][x]

	user_values[y][x] = old_value
	redo_stack.append({ "x": x, "y": y, "old": new_value, "new": old_value })

	var cell = problem_puzzle.get_child(y * 6 + x)
	cell.set_input_value(old_value)
	highlight_row_and_col(x, y)

func redo():
	if redo_stack.is_empty():
		return

	var move = redo_stack.pop_back()
	var x = move["x"]
	var y = move["y"]
	var new_value = move["new"]
	var old_value = user_values[y][x]

	user_values[y][x] = new_value
	undo_stack.append({ "x": x, "y": y, "old": old_value, "new": new_value })

	var cell = problem_puzzle.get_child(y * 6 + x)
	cell.set_input_value(new_value)
	highlight_row_and_col(x, y)
#endregion

#region Validation Helpers
func is_row_valid(y: int) -> bool:
	var row_ones = 0
	var row_zeros = 0

	for i in range(6):
		match user_values[y][i]:
			1: row_ones += 1
			0: row_zeros += 1

	if row_ones > 3 or row_zeros > 3:
		return false

	return !has_consecutive_threes(user_values[y])

func is_col_valid(x: int) -> bool:
	var col_ones = 0
	var col_zeros = 0
	var column = []

	for i in range(6):
		column.append(user_values[i][x])
		match user_values[i][x]:
			1: col_ones += 1
			0: col_zeros += 1

	if col_ones > 3 or col_zeros > 3:
		return false

	return !has_consecutive_threes(column)

func has_consecutive_threes(line: Array) -> bool:
	var consecutive_ones = 0
	var consecutive_zeros = 0

	for val in line:
		match val:
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

#region Highlight Management
func highlight_row_and_col(x: int, y: int) -> void:
	clear_row_and_col(x, y)
	if !is_row_valid(y):
		for i in range(6):
			animate_error_flash(problem_puzzle.get_child(y * 6 + i))

	if !is_col_valid(x):
		for i in range(6):
			animate_error_flash(problem_puzzle.get_child(i * 6 + x))

func clear_row_and_col(x: int, y: int) -> void:
	for i in range(6):
		problem_puzzle.get_child(y * 6 + i).show_error(false)
		problem_puzzle.get_child(i * 6 + x).show_error(false)
#endregion

#region Win Condition
func check_for_win() -> void:
	for y in range(6):
		for x in range(6):
			if user_values[y][x] == -1:
				return

	for i in range(6):
		if !is_row_valid(i) or !is_col_valid(i):
			return

	lock_all_cells()

func lock_all_cells() -> void:
	puzzle_completed.emit()
	celebrate_win()
#endregion

func clear_puzzle() -> void:
	for child in problem_puzzle.get_children():
		child.queue_free()
	user_values.clear()
	undo_stack.clear()
	redo_stack.clear()

func reset_puzzle() -> void:
	for value in user_values:
		print(value)
	print("-----")


#region Tween Animations - Completely Isolated
var active_tweens: Array[Tween] = []

func clear_all_tweens():
	for tween in active_tweens:
		tween.kill()
	active_tweens.clear()

func animate_cell_click(cell: Control):
	var tween = create_tween()
	active_tweens.append(tween)
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(cell, "scale", Vector2(0.95, 0.95), 0.1)
	tween.tween_property(cell, "scale", Vector2(1.0, 1.0), 0.3)

func highlight_row(y: int, is_error: bool):
	for x in range(6):
		var cell = problem_puzzle.get_child(y * 6 + x)
		if is_error:
			animate_error_flash(cell)
		else:
			animate_success_pulse(cell)

func highlight_column(x: int, is_error: bool):
	for y in range(6):
		var cell = problem_puzzle.get_child(y * 6 + x)
		if is_error:
			animate_error_flash(cell)
		else:
			animate_success_pulse(cell)

func clear_highlights():
	clear_all_tweens()
	for cell in problem_puzzle.get_children():
		cell.modulate = Color.WHITE

func animate_error_flash(cell: Control):
	var tween = create_tween()
	active_tweens.append(tween)
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(cell, "modulate", Color(1, 0.5, 0.5), 0.1)
	tween.tween_property(cell, "modulate", Color.WHITE, 0.2)
	tween.set_loops(2)
	cell.show_error(true)

func animate_success_pulse(cell: Control):
	var tween = create_tween()
	active_tweens.append(tween)
	tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(cell, "modulate", Color(0.9, 1, 0.9), 0.2)
	tween.tween_property(cell, "modulate", Color.WHITE, 0.4)

func celebrate_win():
	puzzle_completed.emit()
	var delay = 0.0
	for i in range(problem_puzzle.get_child_count()):
		var cell = problem_puzzle.get_child(i)
		var tween = create_tween()
		active_tweens.append(tween)
		tween.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
		tween.tween_interval(delay)
		tween.tween_property(cell, "scale", Vector2(1.2, 1.2), 0.3)
		tween.tween_property(cell, "scale", Vector2(1.0, 1.0), 0.5)
		delay += 0.05
		cell.lock()
#endregion
