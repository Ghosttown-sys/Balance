class_name Level_Grid
extends GridContainer

const LEVEL_GRID = preload("res://playable/level_ui/level_grid.tscn")
const LEVELS_PER_PAGE : int = 60

@export_file("*.tscn") var main_scene: String

@export var spawn_delay: float = 0.03
@export var spawn_duration: float = 0.2
@export var spawn_scale_start: float = 0.5
@export var spawn_rotation_start: float = 15

var current_unlocked_level := 1
var current_played_level := 0
var spawn_tweens: Array[Tween] = []
var is_animating := false

signal updated(what : bool)

func spawn_levels(start_level: int, count: int):
	load_level_progress()
	is_animating = true
	updated.emit(is_animating)

	#var total_iterations = count
	#var current_iteration = 0

	for i in range(start_level, start_level + count):
		var tile = LEVEL_GRID.instantiate()
		var level_num = i + 1
		var is_unlocked = level_num <= current_unlocked_level
		var is_played = level_num <= current_played_level
		tile.set_level(level_num, is_unlocked, is_played)
		tile.connect("level_selected", _on_level_selected)
		await get_tree().create_timer(0.01).timeout
		add_child(tile)
	is_animating = false
	updated.emit(is_animating)

func load_level_progress():
	current_unlocked_level = Game.current_level_index + 1
	current_played_level = Game.current_level_index


func _check_animation_complete():
	if spawn_tweens.all(func(t): return not t.is_running()):
		is_animating = false
		updated.emit(is_animating)

func _on_level_selected(level: int):
	Game.transition_level = level
	Transition_Manager.transition_to(main_scene)
