class_name Main
extends Node

@onready var puzzle: Puzzle_Handler = %Puzzle
@onready var camera: Camera2D = %Camera
@onready var level: Label = %Level
@onready var next_level: Button = %Next_Level
@onready var level_clear: Label = %"Level Clear"
@onready var retry_button: Button = %Retry

var current_level := 0
var current_difficulty := 0.5

func _ready() -> void:
	puzzle.puzzle_completed.connect(_on_puzzle_completed)
	start_level()

func _on_next_level_pressed() -> void:
	current_level += 1
	start_level()

func _on_retry_pressed() -> void:
	start_level()

func start_level() -> void:
	level.text = "Level %d" % (current_level + 1)
	level_clear.visible = false
	next_level.visible = false
	retry_button.visible = true
	puzzle.clear_puzzle()
	puzzle.set_puzzle(current_level, current_difficulty)

func _on_puzzle_completed() -> void:
	level_clear.visible = true
	next_level.visible = true
	retry_button.visible = false
