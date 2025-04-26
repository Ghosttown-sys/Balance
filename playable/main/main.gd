class_name Main
extends Node

@onready var puzzle: Puzzle_Handler = %Puzzle
@onready var camera: Camera2D = %Camera
@onready var level: Label = %Level
@onready var next_level: Button = %Next_Level
@onready var level_clear: Label = %"Level Clear"
@onready var reset_button: Button = %Reset
@onready var difficulty: Label = %difficulty


var current_difficulty : float:
	get():
		return clamp((Game.current_level_index + 2) * 0.05,0.1,1.0)
var complexcity := 1
@onready var diifculty_slider: HSlider = %Diifculty_Slider

func _ready() -> void:
	reset_button.pressed.connect(_on_reset_pressed)
	current_difficulty = Game.current_difficulty
	diifculty_slider.value = current_difficulty
	print(current_difficulty)
	puzzle.puzzle_completed.connect(_on_puzzle_completed)
	Game.current_level_index = Game.transition_level
	start_level()


func _on_next_level_pressed() -> void:
	Game.complete_current_level()
	start_level()

func _on_reset_pressed() -> void:
	start_level()


func start_level() -> void:
	level_clear.text = ""
	if Game.current_level_index > Game.highest_level_index:
		next_level.hide()
	#reset_button.hide()
	puzzle.clear_puzzle()
	level.text = "Level %d" % (Game.current_level_index)
	puzzle.set_puzzle(Game.current_level_index, current_difficulty, complexcity)


func _on_puzzle_completed() -> void:
	level_clear.text = "Level Cleared!"
	next_level.visible = true
	Game.highest_level_index = max(Game.highest_level_index, Game.current_level_index)


func _on_diifculty_slider_drag_ended(value_changed: bool) -> void:
	if !value_changed:
		return

	current_difficulty = diifculty_slider.value
	Game.current_difficulty = current_difficulty
	start_level()


func _on_diifculty_slider_value_changed(value: float) -> void:
	difficulty.text = str(value)
