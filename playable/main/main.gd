class_name Main
extends Node

@onready var puzzle: Puzzle_Handler = %Puzzle
@onready var camera: Camera2D = %Camera
@onready var level: Label = %Level
@onready var next_level: Button = %Next_Level
@onready var level_clear: Label = %"Level Clear"
@onready var retry_button: Button = %Retry

var current_difficulty := 0.5
var complexcity := 1

func _ready() -> void:
	puzzle.puzzle_completed.connect(_on_puzzle_completed)
	Game.current_level_index = Game.transition_level-1
	start_level()


func _on_next_level_pressed() -> void:
	Game.complete_current_level()
	start_level()

func _on_retry_pressed() -> void:
	start_level()

func start_level() -> void:
	level_clear.visible = false
	next_level.visible = false
	retry_button.visible = true
	puzzle.clear_puzzle()
	level.text = "Level %d" % (Game.current_level_index + 1)
	puzzle.set_puzzle(Game.current_level_index, current_difficulty, complexcity)

func _on_puzzle_completed() -> void:
	level_clear.visible = true
	next_level.visible = true
	retry_button.visible = false
