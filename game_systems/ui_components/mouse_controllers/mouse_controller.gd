extends Node2D

const LEFT_MOUSE_BUTTON = preload("res://assets/mouse/left_mouse_button_light.png")
const MIDDLE_MOUSE_BUTTON = preload("res://assets/mouse/middle_mouse_button_light.png")
const RIGHT_MOUSE_BUTTON = preload("res://assets/mouse/right_mouse_button_light.png")
const MOUSE_LIGHT = preload("res://assets/mouse/mouse_light.png")
const TAP = preload("res://assets/mouse/tap.png")

@onready var cursor: Sprite2D = %Cursor
var mouse_position: Vector2
var parent

func _ready() -> void:
	parent = get_parent()

func _process(_delta: float) -> void:
	mouse_position = get_global_mouse_position()
	cursor.position = lerp(cursor.position, mouse_position, 0.25)
	parent.mouse_position = cursor.position
	
	update_cursor_texture()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse"):
		cursor.texture = LEFT_MOUSE_BUTTON
	elif event.is_action_pressed("right_mouse"):
		cursor.texture = RIGHT_MOUSE_BUTTON
	elif event.is_action_pressed("middle_mouse"):
		cursor.texture = MIDDLE_MOUSE_BUTTON
	elif event.is_action_released("left_mouse") or \
		event.is_action_released("right_mouse") or \
		event.is_action_released("middle_mouse"):
		cursor.texture = MOUSE_LIGHT

func update_cursor_texture() -> void:
	if Input.is_action_pressed("left_mouse"):
		cursor.texture = LEFT_MOUSE_BUTTON
	elif Input.is_action_pressed("right_mouse"):
		cursor.texture = RIGHT_MOUSE_BUTTON
	elif Input.is_action_pressed("middle_mouse"):
		cursor.texture = MIDDLE_MOUSE_BUTTON
	else:
		cursor.texture = MOUSE_LIGHT
