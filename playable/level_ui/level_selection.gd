extends Control

@export var level_holder: GridContainer
const LEVEL_GRID = preload("res://playable/level_ui/level_grid.tscn")
const LEVELS_PER_PAGE := 60

var current_unlocked_level := 1
var current_played_level := 0

func _ready():
	load_level_progress()
	var current_page_start := int(Game.current_level_index / LEVELS_PER_PAGE) * LEVELS_PER_PAGE
	spawn_levels(current_page_start, LEVELS_PER_PAGE)

func load_level_progress():
	current_unlocked_level = Game.current_level_index + 1
	current_played_level = Game.current_level_index

func spawn_levels(start_level: int, count: int):
	clear_grid()
	
	for i in range(start_level, start_level + count):
		var tile = LEVEL_GRID.instantiate()
		var level_num = i + 1
		var is_unlocked = level_num <= current_unlocked_level
		var is_played = level_num <= current_played_level

		tile.set_level(level_num, is_unlocked, is_played) 
		tile.connect("level_selected", _on_level_selected)
		level_holder.add_child(tile)

func _on_level_selected(level: int):
	print("Level selected: ", level)

func clear_grid():
	for child in level_holder.get_children():
		child.queue_free()
