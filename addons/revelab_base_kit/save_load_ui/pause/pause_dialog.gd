extends Control

signal pause_about_to_show()
signal pausing_game
signal resuming_game

#@onready var _save_game_dlg = $Save_Game
#@onready var _load_game_dlg = $Load_Game
@onready var _pause_button = $Pause_Button
@onready var options_btn: Button = %OptionsBtn
@onready var _bg = $Bg
@onready var _pause_menu = $VBoxContainer

@onready var nodes_grp1 = [_pause_button]
@onready var nodes_grp2 = [_bg, _pause_menu]

var _image_for_save: Image

func _ready():
	pause_hide()

func pause_hide():
	resuming_game.emit()
	for n in nodes_grp1:
		if n:
			n.show()
	for n in nodes_grp2:
		if n:
			n.hide()

func pause_show():
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


#func _on_SaveBtn_pressed():
	#_save_game_dlg.show_save_dlg(_image_for_save)

#func _on_LoadBtn_pressed():
	#pause_hide()
	#_pause_button.hide()
	#_load_game_dlg.show_modal()

func _on_MainMenuBtn_pressed():
	pause_hide()
	_pause_button.hide()
	Transition_Manager.transition_to("uid://c8ndj7bvsf8pv")

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
	await get_tree().create_timer(0.1).timeout
	return get_viewport().get_texture().get_image()


func _on_pause_button_pressed():
	_show()
