extends MarginContainer

#@onready var title: Label = %Title
#@onready var rule_1: Label = %Rule_1
#@onready var rule_2: Label = %Rule_2
#@onready var rule_3: Label = %Rule_3
#@onready var animation_timer: Timer = %AnimationTimer
#@onready var tween: Tween
@onready var close_button_1: Button = %CloseButton1
@onready var bullet_points_1: VBoxContainer = %BulletPoints1
@onready var close_button_2: Button = %CloseButton2
@onready var bullet_points_2: VBoxContainer = %BulletPoints2

var showing_rules := true
var is_animating := false

func _ready():
	#update_texts()
	
	#animation_timer.timeout.connect(_on_animation_timer_timeout)
	#animation_timer.wait_time = 6.0
	#animation_timer.start()
	
	close_button_1.pressed.connect(_on_close_button_1_pressed)
	close_button_2.pressed.connect(_on_close_button_2_pressed)


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


#func update_texts():
	#if showing_rules:
		#title.text = "Controls"
		#rule_1.text = "Left click to cycle through icons"
		#rule_2.text = "Right click to remove symbols"
		#rule_3.text = "Adjust difficulty in the right side slider , Click Clear to clear level , Next to go next level ! "
		#
	#else:
		#title.text = "Puzzle Rules"
		#rule_1.text = "Fill the Grid"
		#rule_2.text = "Each row & column must contain exactly 3 Suns and 3 Moons"
		#rule_3.text = "No 3 Suns or 3 Moons can appear consecutively in any row or column"
#
#func _on_animation_timer_timeout():
	#if is_animating:
		#return
		#
	#is_animating = true
	#showing_rules = !showing_rules
	#
	#if tween:
		#tween.kill()
	#tween = create_tween()
	#tween.set_parallel(true)
	#
	#tween.tween_property(title, "modulate:a", 0.0, 0.6)
	#tween.tween_property(rule_1, "modulate:a", 0.0, 0.6)
	#tween.tween_property(rule_2, "modulate:a", 0.0, 0.6)
	#tween.tween_property(rule_3, "modulate:a", 0.0, 0.6)
	#tween.chain().tween_callback(update_texts)
	#tween.tween_property(title, "modulate:a", 1.0, 0.6)
	#tween.tween_property(rule_1, "modulate:a", 1.0, 0.6)
	#tween.tween_property(rule_2, "modulate:a", 1.0, 0.6)
	#tween.tween_property(rule_3, "modulate:a", 1.0, 0.6)
	#
	#tween.chain().tween_callback(_on_animation_complete)
#
#func _on_animation_complete():
	#is_animating = false
