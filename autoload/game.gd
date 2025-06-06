extends Node

const TOTAL_TUTORIALS := 6
const SAVE_PATH := "user://save_data.json"
const PROGRESS_PATH := "user://progress.json"

signal game_paused
signal game_unpaused

var current_level_index : int = 1
var highest_level_index : int = 0
var is_in_tutorial := false
var tutorials_completed := false

var player_name := ""
var current_score := 0
var high_score := 0

var current_difficulty := 0.0
var transition_level := 0

func _ready():
	game_paused.connect(_on_game_paused)
	game_unpaused.connect(_on_game_unpaused)
	set_deferred("process_mode", ProcessMode.PROCESS_MODE_ALWAYS)
	load_data()
	load_progress()
	start_next_level()

func start_next_level():
	is_in_tutorial = false
	load_regular_level(current_level_index)

func load_tutorial_level(index: int):
	is_in_tutorial = true
	print("Loading tutorial level: %d" % index)

func load_regular_level(index: int):
	is_in_tutorial = false
	print("Loading regular level: %d" % index)

func complete_current_level():
	if is_in_tutorial:
		tutorials_completed = true
		save_progress()
	else:
		current_level_index += 1
		if current_score > high_score:
			high_score = current_score
			save_data()
		save_progress()
	start_next_level()

func save_progress():
	var progress_data = {
		"current_level_index": current_level_index,
		"highest_level_index" : highest_level_index,
		"tutorials_completed": tutorials_completed,
		"current_difficulty" : current_difficulty
	}
	var file = FileAccess.open(PROGRESS_PATH, FileAccess.WRITE)
	file.store_line(JSON.stringify(progress_data))
	file.close()

func load_progress():
	if not FileAccess.file_exists(PROGRESS_PATH):
		print("No progress file found.")
		return
	var file = FileAccess.open(PROGRESS_PATH, FileAccess.READ)
	var content = file.get_as_text()
	file.close()

	var progress_data = JSON.parse_string(content)
	if progress_data:
		current_level_index = progress_data.get("current_level_index", 1)
		highest_level_index = progress_data.get("highest_level_index", 0)
		tutorials_completed = progress_data.get("tutorials_completed", false)
		current_difficulty = progress_data.get("current_difficulty",0.0)

func save_data():
	@warning_ignore("shadowed_variable")
	var save_data = {
		"player_name": player_name,
		"high_score": high_score,
	}
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_line(JSON.stringify(save_data))
	file.close()

func load_data():
	if not FileAccess.file_exists(SAVE_PATH):
		print("No save file found.")
		return
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	
	var data = JSON.parse_string(content)
	if data:
		player_name = data.get("player_name", "")
		high_score = data.get("high_score", 0)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if get_tree().paused:
			game_unpaused.emit()
		else:
			game_paused.emit()


func _on_game_paused() -> void:
	#get_tree().paused = true
	pass


func _on_game_unpaused() -> void:
	#get_tree().paused = false
	pass
