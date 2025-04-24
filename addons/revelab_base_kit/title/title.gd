extends Control

@onready var continue_game: Button = %continue_game
@onready var new_game: Button = %new_game
@onready var option: Button = %option
@onready var exit: Button = %exit
@onready var picture: TextureRect = %picture

@export_file("*.tscn") var main_scene: String
@export var defult_image: Texture2D 


func _ready():
	_update_latest_save_picture()
	_toggle_buttons()
	
	if OS.has_feature("web"):
		exit.hide()
	else:
		exit.pressed.connect(_on_exit_button_pressed)


func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _get_latest_save():
	var dir := DirAccess.open(SaveGameDlg.SAVE_GAME_FOLDER)
	if dir == null:
		return ""
	dir.list_dir_begin()
	var files := []
	var file_name = dir.get_next()
	while !file_name.is_empty():
		if file_name.ends_with(".json"):
			files.append(file_name.get_basename())
		file_name = dir.get_next()
	
	files.sort()
	files.reverse()
	return files[0] if files.size() > 0 else ""


func _update_latest_save_picture():
	var latest_save = _get_latest_save()
	if latest_save != "":
		var image_file_name = SaveGameDlg.SAVE_GAME_FOLDER + "/" + latest_save + ".png"
		var image = Image.new()
		if image.load(image_file_name) == OK:
			var texture = ImageTexture.new()
			texture.set_image(image)
			picture.texture = texture
			return
	
	picture.texture = defult_image


func _toggle_buttons():
	var has_save = _get_latest_save() != ""
	continue_game.visible = has_save
	new_game.visible = !has_save
	option.visible = false


#func _on_ContinueGameBtn_pressed():
	#var latest_save = _get_latest_save()
	#if latest_save != "":
		#var save_file_name = SaveGameDlg.SAVE_GAME_FOLDER + "/" + latest_save + ".json"
		#Save_Service.load_game_state(save_file_name, Transition_Manager.transition_to)
#

func _on_NewGameBtn_pressed():
	Save_Service.new_game()
	Transition_Manager.transition_to(main_scene)


func _on_OptionBtn_pressed():
	_delete_all_saves()
	_toggle_buttons()
	_update_latest_save_picture()


func _delete_all_saves():
	var dir := DirAccess.open(SaveGameDlg.SAVE_GAME_FOLDER)
	if dir == null:
		return
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while !file_name.is_empty():
		if file_name.ends_with(".json") or file_name.ends_with(".png"):
			dir.remove(file_name)
		file_name = dir.get_next()
