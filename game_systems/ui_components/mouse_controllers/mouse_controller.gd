extends Node2D

const LEFT_MOUSE_BUTTON = preload("res://assets/mouse/left_mouse_button_light.png")
const MIDDLE_MOUSE_BUTTON = preload("res://assets/mouse/middle_mouse_button_light.png")
const RIGHT_MOUSE_BUTTON = preload("res://assets/mouse/right_mouse_button_light.png")
const MOUSE_LIGHT = preload("res://assets/mouse/mouse_light.png")
const TAP = preload("res://assets/mouse/tap.png")

@onready var cursor: Sprite2D = %Cursor
@onready var parent : Node = get_parent()
var mouse_position: Vector2:
	get():
		return get_global_mouse_position()


func _process(_delta: float) -> void:
	cursor.position = lerp(cursor.position, mouse_position, 0.25)
	parent.mouse_position = cursor.position
