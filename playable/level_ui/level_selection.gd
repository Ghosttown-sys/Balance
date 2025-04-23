extends Control

@export var level_holder: GridContainer
const LEVEL_GRID = preload("res://playable/level_ui/level_grid.tscn")
const LEVELS_PER_PAGE : int = 60

@export_file("*.tscn") var main_scene: String

@export var spawn_delay: float = 0.05 
@export var spawn_duration: float = 0.3  
@export var spawn_scale_start: float = 0.5 
@export var spawn_rotation_start: float = 15 

var current_unlocked_level := 1
var current_played_level := 0
var spawn_tweens: Array[Tween] = []

func _ready():
	load_level_progress()
	@warning_ignore("integer_division")
	var current_page_start := int(Game.current_level_index / LEVELS_PER_PAGE) * LEVELS_PER_PAGE
	spawn_levels(current_page_start, LEVELS_PER_PAGE)

func load_level_progress():
	current_unlocked_level = Game.current_level_index + 1
	current_played_level = Game.current_level_index

func spawn_levels(start_level: int, count: int):
	clear_grid()
	clear_spawn_tweens()
	
	for i in range(start_level, start_level + count):
		var tile = LEVEL_GRID.instantiate()
		var level_num = i + 1
		var is_unlocked = level_num <= current_unlocked_level
		var is_played = level_num <= current_played_level

		tile.set_level(level_num, is_unlocked, is_played)
		tile.connect("level_selected", _on_level_selected)
		level_holder.add_child(tile)
		
		tile.scale = Vector2(spawn_scale_start, spawn_scale_start)
		tile.rotation_degrees = spawn_rotation_start * (1 if i % 2 == 0 else -1)
		tile.modulate.a = 0
		
		var tween = create_tween()
		spawn_tweens.append(tween)
		tween.tween_interval(i * spawn_delay)
		tween.tween_property(tile, "scale", Vector2(1, 1), spawn_duration).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tween.parallel().tween_property(tile, "rotation_degrees", 0, spawn_duration * 1.2)
		tween.parallel().tween_property(tile, "modulate:a", 1, spawn_duration * 0.8)

func _on_level_selected(level: int):
	Game.transition_level = level
	Transition_Manager.transition_to(main_scene)

func clear_grid():
	clear_spawn_tweens()
	for child in level_holder.get_children():
		child.queue_free()

func clear_spawn_tweens():
	for tween in spawn_tweens:
		if tween != null and tween.is_valid():
			tween.kill()
	spawn_tweens.clear()
