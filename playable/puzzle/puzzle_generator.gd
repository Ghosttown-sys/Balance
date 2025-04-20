class_name PUZZLE_GENERATOR
extends Node

const VALID_ROWS = [
	[0, 0, 1, 0, 1, 1], [0, 0, 1, 1, 0, 1], [0, 1, 0, 0, 1, 1], [0, 1, 0, 1, 0, 1], [0, 1, 0, 1, 1, 0],
	[0, 1, 1, 0, 0, 1], [0, 1, 1, 0, 1, 0], [1, 0, 0, 1, 0, 1], [1, 0, 0, 1, 1, 0], [1, 0, 1, 0, 0, 1],
	[1, 0, 1, 0, 1, 0], [1, 0, 1, 1, 0, 0], [1, 1, 0, 0, 1, 0], [1, 1, 0, 1, 0, 0]
]

var rng = RandomNumberGenerator.new()

func generate_puzzle(level_seed: int, difficulty: float = 0.5,complexity : int = 1) -> Dictionary:
	rng.seed = level_seed
	var solution := []
	while solution.is_empty():
		solution = try_generate_board()
	var puzzle = duplicate_board(solution)
	var cells_removed = create_solvable_puzzle(puzzle, difficulty)
	
	var valid_input := []
	if complexity ==1 :
		valid_input = [0,1]
		
	return {
		"solution": solution,
		"puzzle": puzzle,
		"cells_removed": cells_removed,
		"valid_inputs": valid_input
	}


func try_generate_board() -> Array:
	var board = []
	var col_counts = [0, 0, 0, 0, 0, 0]
	var last_two = []
	for i in range(6):
		last_two.append([null, null])

	for i in range(6):
		var valid_rows = get_valid_rows(col_counts, last_two)
		if valid_rows.is_empty():
			return []
		var row = valid_rows[rng.randi_range(0, valid_rows.size() - 1)]
		board.append(row.duplicate())

		for col in range(6):
			col_counts[col] += row[col]
			last_two[col][0] = last_two[col][1]
			last_two[col][1] = row[col]

	return board

func create_solvable_puzzle(board: Array, difficulty: float) -> int:
	var cells_to_keep = int(36 * (1.0 - difficulty))
	cells_to_keep = clamp(cells_to_keep, 8, 30)

	var max_per_line := int(lerp(6.0, 2.0, difficulty))

	var positions := []
	for row in range(6):
		for col in range(6):
			positions.append(Vector2(col, row))

	shuffle_with_rng(positions, rng)

	var row_counts := [0, 0, 0, 0, 0, 0]
	var col_counts := [0, 0, 0, 0, 0, 0]
	var keep_mask := {}

	for pos in positions:
		if keep_mask.size() >= cells_to_keep:
			break

		var row = pos.y
		var col = pos.x

		if row_counts[row] >= max_per_line or col_counts[col] >= max_per_line:
			continue

		keep_mask[pos] = true
		row_counts[row] += 1
		col_counts[col] += 1

	var cells_removed := 0
	for row in range(6):
		for col in range(6):
			var pos := Vector2(col, row)
			if not keep_mask.has(pos):
				var original = board[row][col]
				board[row][col] = -1
				if not is_uniquely_solvable(board, original):
					board[row][col] = original
				else:
					cells_removed += 1

	return cells_removed

func is_uniquely_solvable(puzzle: Array, original_value: int) -> bool:
	var test_puzzle = duplicate_board(puzzle)
	for test_value in [0, 1]:
		if test_value == original_value:
			continue
		if is_valid_solution(test_puzzle, test_value):
			return false
	return true

func is_valid_solution(grid: Array, test_value: int) -> bool:
	for row in grid:
		var ones = 0
		var zeros = 0
		for val in row:
			if val == 1:
				ones += 1
			elif val == 0:
				zeros += 1
			else:
				if test_value == 1:
					ones += 1
				else:
					zeros += 1
		if ones != 3 or zeros != 3:
			return false
		for i in range(4):
			var a = row[i] if row[i] != -1 else test_value
			var b = row[i + 1] if row[i + 1] != -1 else test_value
			var c = row[i + 2] if row[i + 2] != -1 else test_value
			if a == b and b == c:
				return false

	for col in range(6):
		var col_vals = []
		for row in grid:
			col_vals.append(row[col])
		var ones = 0
		var zeros = 0
		for val in col_vals:
			if val == 1:
				ones += 1
			elif val == 0:
				zeros += 1
			else:
				if test_value == 1:
					ones += 1
				else:
					zeros += 1
		if ones != 3 or zeros != 3:
			return false
		for i in range(4):
			var a = col_vals[i] if col_vals[i] != -1 else test_value
			var b = col_vals[i + 1] if col_vals[i + 1] != -1 else test_value
			var c = col_vals[i + 2] if col_vals[i + 2] != -1 else test_value
			if a == b and b == c:
				return false

	return true

func get_valid_rows(col_counts: Array, last_two: Array) -> Array:
	var valid = []
	for row in VALID_ROWS:
		var valid_row = true
		for col in range(6):
			if col_counts[col] + row[col] > 3:
				valid_row = false
				break
			if last_two[col][0] == last_two[col][1] and last_two[col][1] == row[col]:
				valid_row = false
				break
		if valid_row:
			valid.append(row.duplicate())
	return valid

func duplicate_board(board: Array) -> Array:
	var new_board = []
	for row in board:
		new_board.append(row.duplicate())
	return new_board

func shuffle_with_rng(array: Array, rng: RandomNumberGenerator) -> void:
	for i in range(array.size() - 1, 0, -1):
		var j = rng.randi_range(0, i)
		var temp = array[i]
		array[i] = array[j]
		array[j] = temp
