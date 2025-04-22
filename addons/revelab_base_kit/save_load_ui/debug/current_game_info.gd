extends AcceptDialog

@onready var info: TextEdit = %info

func _ready() -> void:
	visible = false

func show_modal() -> void:
	info.text = Save_Service.get_game_state_string(true)
	get_tree().paused = true
	popup_centered()

func _on_RawGameStateDlg_confirmed() -> void:
	get_tree().paused = false
	

func _on_close_requested() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	_on_RawGameStateDlg_confirmed()
