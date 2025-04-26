extends Control

const LEVELS_PER_PAGE : int = 24

var current_unlocked_level := 1
var current_played_level := 0
var is_animating := false

@onready var pevious: Button = %pevious
@onready var next: Button = %next

var current_page_index := 0

var current_grid : Level_Grid

const LEVELS = preload("res://playable/level_ui/levels.tscn")

func _ready():
	update_navigation_buttons(true)
	var current_page_start := current_page_index * LEVELS_PER_PAGE
	
	if current_grid:
		current_grid.queue_free()
		
	var temp_grid = LEVELS.instantiate()
	current_grid = temp_grid
	current_grid.updated.connect(update_navigation_buttons)
	add_child(current_grid)
	current_grid.spawn_levels(current_page_start, LEVELS_PER_PAGE)
	


func _on_pevious_pressed() -> void:
	if current_page_index > 0 and not is_animating:
		current_page_index -= 1
		var current_page_start := current_page_index * LEVELS_PER_PAGE
		if current_grid:
			current_grid.queue_free()
			
		var temp_grid = LEVELS.instantiate()
		current_grid = temp_grid
		current_grid.updated.connect(update_navigation_buttons)
		add_child(current_grid)
		current_grid.spawn_levels(current_page_start, LEVELS_PER_PAGE)
		

func _on_next_pressed() -> void:
	if not is_animating:
		current_page_index += 1
		var current_page_start := current_page_index * LEVELS_PER_PAGE
		
		if current_grid:
			current_grid.queue_free()
			
		var temp_grid = LEVELS.instantiate()
		current_grid = temp_grid
		current_grid.updated.connect(update_navigation_buttons)
		add_child(current_grid)
		current_grid.spawn_levels(current_page_start, LEVELS_PER_PAGE)
		

func update_navigation_buttons(what):
	is_animating = what
	pevious.disabled = current_page_index == 0 or is_animating
	next.disabled = is_animating
