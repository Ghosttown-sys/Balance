class_name Hud
extends CanvasLayer

@onready var _auto_save_icon: TextureRect = %Auto_Save
@onready var _auto_save_animation_player: AnimationPlayer = %Auto_Save_Animation_Player
@onready var game_info: AcceptDialog = $Game_Info

func _ready() -> void:
	_auto_save_icon.visible = false


func _input(event:InputEvent) -> void:
	if event.is_action("autosave_on"):
		_auto_save_icon.visible = true
	if event.is_action("autosave_off"):
		_auto_save_animation_player.play("disk_exit")
	if event.is_action_pressed("debug"):
		game_info.show_modal()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_auto_save_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "RESET":
		return
	_auto_save_icon.visible = false
	_auto_save_animation_player.play("RESET")
