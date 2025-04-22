extends Control

signal pause_about_to_show()
signal pausing_game
signal resuming_game

@onready var _save_game_dlg = $Save_Game
#@onready var _load_game_dlg = $Load_Game
@onready var _pause_button = $Pause_Button
@onready var options_btn: Button = %OptionsBtn
@onready var _bg = $Bg
@onready var _pause_menu = $VBoxContainer

@onready var nodes_grp1 = [_pause_button]
@onready var nodes_grp2 = [_bg, _pause_menu]

var _image_for_save: Image
var _mouse_request_id: int = -1

func _ready():
	pause_hide()

func pause_hide():
	show_game_ui()
	resuming_game.emit()
	for n in nodes_grp1:
		if n:
			n.show()
	for n in nodes_grp2:
		if n:
			n.hide()

func hide_game_ui():
	var game_ui = get_tree().get_first_node_in_group("ui")
	game_ui.visible = false

func show_game_ui():
	var game_ui = get_tree().get_first_node_in_group("ui")
	game_ui.visible = true

func pause_show():
	hide_game_ui()
	pausing_game.emit()
	for n in nodes_grp1:
		n.hide()
	for n in nodes_grp2:
		n.show()

func _on_ResumeBtn_pressed():
	_image_for_save = null
	pause_hide()
	get_tree().paused = false
	process_mode = Node.PROCESS_MODE_PAUSABLE


func _on_SaveBtn_pressed():
	_save_game_dlg.show_save_dlg(_image_for_save)

#func _on_LoadBtn_pressed():
	#pause_hide()
	#_pause_button.hide()
	#_load_game_dlg.show_modal()

func _on_MainMenuBtn_pressed():
	pause_hide()
	_pause_button.hide()
	Transition_Manager.transition_to("uid://d4ctu5fytr7ag")

func _show() -> void:
	_image_for_save = await _get_screenshot()
	emit_signal("pause_about_to_show")
	process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true
	pause_show()

func _input(_event):
	if Input.is_action_just_pressed("pause"):
		_show()

func _get_screenshot() -> Image:
	hide_game_ui()
	await get_tree().create_timer(0.1).timeout
	return get_viewport().get_texture().get_image()


func _on_pause_button_pressed():
	_show()
