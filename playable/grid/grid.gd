extends Control

#region Variables
const DEFAULT = preload("res://assets/grid/default.png")

const MOON = preload("res://assets/symbols/Moon.png")
const SUN = preload("res://assets/symbols/Sun.png")
const RAIN = preload("res://assets/symbols/Rain.png")
const SNOW = preload("res://assets/symbols/Snow.png")
const THUNDER = preload("res://assets/symbols/Thunder.png")
const WIND = preload("res://assets/symbols/Wind.png")

@export var icon: TextureRect
@export var box: TextureRect
@export var border: TextureRect
@export var value: int = -1

var is_default_piece: bool = false
var is_showing_error: bool = false
var error_count: int = 0
var locked: bool = false

signal value_changed(new_value: int)

var SYMBOLS := {
	0: { "texture": MOON, "color": "#a4d6f8" },        
	1: { "texture": SUN, "color": "#ffd965" },        
	2: { "texture": RAIN, "color": "#00bfff" },        
	3: { "texture": SNOW, "color": "#00f0ff" },       
	4: { "texture": THUNDER, "color": "#bf40bf" },     
	5: { "texture": WIND, "color": "#7fffd4" }        
}


@export var moon_color: String = "#a4d6f8"
@export var sun_color: String = "#ffd965"
@export var error_color: String = "#ff4c4c"
@export var locked_color: String = "#aaffaa"
@export var user_piece_color: String = "#ffffff"
@export var default_color: String = "#1A1E2A"
@export var user_piece_bg_color : String = "#161616"

var current_valid_inputs :=[]
var tween: Tween
#endregion

#region Setup
func _ready():
	set_process_input(true)

func set_grid(num: int, valid_values: Array):
	current_valid_inputs = valid_values.duplicate()
	
	if num in valid_values:
		is_default_piece = true
		value = num
	else:
		is_default_piece = false
		value = -1

	update_visuals()

func set_input_value(new_value: int) -> void:
	if is_default_piece:
		return

	value = new_value
	update_visuals()


#endregion

#region Input Handling
func _on_mouse_entered() -> void:
	if locked or is_default_piece:
		return
	border.set_light_mask(2)
	animate_hover_scale(true)

func _on_mouse_exited() -> void:
	border.set_light_mask(1)
	animate_hover_scale(false)

func _on_gui_input(event: InputEvent) -> void:
	if is_default_piece or locked:
		return
	
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			cycle_forward()
			animate_click()
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			set_user_value(-1) # blank/reset
			animate_click()

func cycle_forward():
	if current_valid_inputs.is_empty():
		return
	
	var idx = current_valid_inputs.find(value)
	idx = (idx + 1) % current_valid_inputs.size()
	set_user_value(current_valid_inputs[idx])

#endregion

#region User Interaction
func set_user_value(val: int):
	if is_default_piece or locked:
		return
	value = val
	update_visuals()
	value_changed.emit(value)

func show_error(is_error: bool) -> void:
	if is_error:
		error_count += 1
	else:
		error_count =0
	
	error_count = max(0, error_count)
	is_showing_error = error_count > 0
	update_visuals()

	if is_showing_error:
		animate_error_flash()
	else:
		animate_neutral_state()
		
func lock():
	locked = true
	update_visuals()
	animate_lock()
#endregion

#region Visuals
func update_visuals():
	if value in SYMBOLS:
		icon.texture = SYMBOLS[value]["texture"]
	else:
		icon.texture = null

	box.modulate = Color(default_color) if is_default_piece else Color(user_piece_bg_color)

	if is_showing_error:
		icon.modulate = Color(error_color)
	elif locked:
		icon.modulate = Color(locked_color)
	elif is_default_piece:
		if value in SYMBOLS:
			icon.modulate = Color(SYMBOLS[value]["color"])
	else:
		icon.modulate = Color(user_piece_color)

#endregion

#region Tween Animations
func animate_hover_scale(should_scale: bool) -> void:
	if tween:
		tween.kill()
	tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	var target_scale = Vector2(1.1, 1.1) if should_scale else Vector2(1.0, 1.0)
	tween.tween_property(self, "scale", target_scale, 0.15)

func animate_error_flash() -> void:
	if tween:
		tween.kill()
	
	tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(icon, "modulate", Color(error_color), 0.1)
	tween.tween_callback(update_visuals) 
	tween.tween_property(icon, "modulate", Color(error_color), 0.1)
	tween.tween_callback(update_visuals)

func animate_neutral_state() -> void:
	if tween:
		tween.kill()
	

	tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(icon, "modulate", Color(user_piece_color), 0.1)
	tween.tween_callback(update_visuals)

func animate_click() -> void:
	if tween:
		tween.kill()
	tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.1)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.2)

func animate_lock() -> void:
	if tween:
		tween.kill()
	tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(icon, "modulate:a", 0.5, 0.3)
	tween.tween_property(icon, "modulate:a", 1.0, 0.3)
#endregion
