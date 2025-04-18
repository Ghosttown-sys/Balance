extends Control

#region Variables
var label: Label
var icon: TextureRect

const MOON = preload("res://assets/symbols/Moon01.png")
const SUN = preload("res://assets/symbols/Sun05.png")
@onready var border: TextureRect = $Border

@export var value: int = -1
var is_default_piece: bool = false
var is_showing_error: bool = false
var locked: bool = false

signal value_changed(new_value: int)
#endregion

#region Setup
func _ready():
	label = %Label
	icon = %Icon
	set_process_input(true)

func set_grid(num: int):
	label = %Label
	icon = %Icon

	if num != -1:
		is_default_piece = true
		value = num
	update_visuals()
#endregion

#region Input Handling
func _on_mouse_entered() -> void:
	border.set_light_mask(2)

func _on_mouse_exited() -> void:
	border.set_light_mask(1)

func _on_gui_input(event: InputEvent) -> void:
	if is_default_piece or locked:
		return
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			set_user_value(1 if value != 1 else 0)
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			set_user_value(0 if value != 0 else 1)
#endregion

#region User Interaction
func set_user_value(val: int):
	if is_default_piece or locked:
		return
	value = val
	update_visuals()
	value_changed.emit(value)

func show_error(is_error: bool) -> void:
	is_showing_error = is_error
	update_visuals()

func lock():
	locked = true
	update_visuals()
#endregion

#region Visuals
func update_visuals():
	match value:
		1:
			icon.texture = SUN
		0:
			icon.texture = MOON
		_:
			icon.texture = null

	if is_showing_error:
		icon.modulate = Color.RED
	elif locked:
		icon.modulate = Color8(170, 255, 170) 
	elif is_default_piece:
		match value:
			1:
				icon.modulate = Color8(255, 220, 100)
			0:
				icon.modulate = Color.from_hsv(Color.SKY_BLUE.h, 0.9, 0.95)
	else:
		icon.modulate = Color.WHITE
#endregion
