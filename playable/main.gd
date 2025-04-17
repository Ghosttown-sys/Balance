extends Node

const GRID = preload("res://playable/Grid.tscn")

@onready var problem_puzzle: GridContainer = %problem_puzzle
@onready var solution_puzzle: GridContainer = %solution_puzzle
@onready var puzzle_generator: PUZZLE_GENERATOR = %puzzle_generator

var puzzle := {}

func _ready():
	puzzle = puzzle_generator.generate_puzzle(2, 1.0)

	# Fill both problem and solution grids
	for y in range(6):
		for x in range(6):
			var value = puzzle["puzzle"][y][x]
			var answer = puzzle["solution"][y][x]

			# Problem cell (shows -1 as blank)
			var cell_problem = GRID.instantiate()
			cell_problem.set_grid(value)
			problem_puzzle.add_child(cell_problem)

			# Solution cell (shows correct solution)
			var cell_solution = GRID.instantiate()
			cell_solution.set_grid(answer)
			solution_puzzle.add_child(cell_solution)
