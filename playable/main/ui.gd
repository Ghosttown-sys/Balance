extends Node

@onready var close_button_1: Button = %CloseButton1
@onready var bullet_points_1: VBoxContainer = %BulletPoints1
@onready var close_button_2: Button = %CloseButton2
@onready var bullet_points_2: VBoxContainer = %BulletPoints2
@onready var exit_button: Button = %Exit

var showing_rules := true
var is_animating := false


func _ready():
	close_button_1.pressed.connect(_on_close_button_1_pressed)
	close_button_2.pressed.connect(_on_close_button_2_pressed)
	exit_button.pressed.connect(_on_exit_button_pressed)


func _on_close_button_1_pressed() -> void:
	if bullet_points_1.visible:
		bullet_points_1.hide()
		close_button_1.text = "+"
	else:
		bullet_points_1.show()
		close_button_1.text = "-"


func _on_close_button_2_pressed() -> void:
	if bullet_points_2.visible:
		bullet_points_2.hide()
		close_button_2.text = "+"
	else:
		bullet_points_2.show()
		close_button_2.text = "-"


func _on_exit_button_pressed() -> void:
	Transition_Manager.transition_to("res://playable/level_ui/level_selection.tscn")
