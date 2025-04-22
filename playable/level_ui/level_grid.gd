extends Control

const DEFAULT := preload("res://assets/grid/default.png")

@export var border: TextureRect
@export var box: TextureRect
@export var level_label: Label
@export var level_number: int = -1
@export var is_unlocked: bool = false
@export var is_played: bool = false

@export var blue_high_light: Color = Color("#a4d6f8")
@export var yellow_high_light: Color = Color("#ffd965")
@export var error_color: Color = Color("#ff4c4c")
@export var locked_color: Color = Color("#aaffaa")
@export var user_piece_color: Color = Color("#ffffff")
@export var default_color: Color = Color("#1A1E2A")
@export var user_piece_bg_color: Color = Color("#161616")
@export var green_high_light: Color = Color("#78e1a1")

@export var locked_scale: float = 0.95
@export var unlocked_scale: float = 1.0
@export var played_scale: float = 1.05
@export var hover_scale: float = 1.1

@export var hover_anim_duration: float = 0.15
@export var click_anim_duration: float = 0.2
@export var color_transition_duration: float = 0.2

var tween: Tween
signal level_selected(level: int)

func _ready():
	update_visuals()
	set_process_input(true)

func set_level(num: int, unlocked: bool, played: bool):
	level_number = num
	is_unlocked = unlocked
	is_played = played
	update_visuals()

func _on_mouse_entered():
	if is_unlocked:
		border.set_light_mask(2)
		animate_hover(true)

func _on_mouse_exited():
	border.set_light_mask(1)
	animate_hover(false)

func _on_gui_input(event: InputEvent):
	if not is_unlocked:
		return
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		emit_signal("level_selected", level_number)
		animate_click()

func update_visuals():
	level_label.text = str(level_number)
	border.set_light_mask(1)
	
	if is_played:
		box.modulate = default_color
		level_label.modulate = user_piece_color
		scale = Vector2(played_scale, played_scale)
	elif is_unlocked:
		box.modulate = green_high_light
		level_label.modulate = user_piece_color
		scale = Vector2(unlocked_scale, unlocked_scale)
	else:
		box.modulate = user_piece_bg_color
		level_label.modulate = locked_color
		scale = Vector2(locked_scale, locked_scale)

func animate_hover(should_hover: bool):
	if not is_unlocked:
		return
	
	if tween:
		tween.kill()
	
	tween = create_tween()
	
	if should_hover:
		tween.set_parallel(true)
		tween.tween_property(self, "scale", Vector2(hover_scale, hover_scale), hover_anim_duration)
		tween.tween_property(box, "modulate", yellow_high_light, color_transition_duration)
		tween.tween_property(level_label, "modulate", user_piece_color.lightened(0.2), color_transition_duration)
	else:
		tween.tween_callback(update_visuals)

func animate_click():
	if tween:
		tween.kill()
	
	tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
	var pulse_scale = hover_scale * 0.9
	
	tween.tween_property(self, "scale", Vector2(pulse_scale, pulse_scale), click_anim_duration * 0.5)
	tween.tween_property(self, "scale", Vector2(hover_scale, hover_scale), click_anim_duration * 0.5)
	
	var flash_tween = create_tween()
	flash_tween.tween_property(box, "modulate", yellow_high_light.lightened(0.2), click_anim_duration * 0.3)
	flash_tween.tween_property(box, "modulate", yellow_high_light, click_anim_duration * 0.7)
	flash_tween.tween_callback(update_visuals)
