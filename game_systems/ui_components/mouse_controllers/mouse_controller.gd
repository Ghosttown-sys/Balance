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
	
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("left_mouse") or Input.is_action_just_pressed("right_mouse") or Input.is_action_just_pressed("middle_mouse"):
		Music.play_pop()
