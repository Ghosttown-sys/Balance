extends MarginContainer

@onready var title: Label = $VBoxContainer2/Rules/Title
@onready var rule_1: Label = %Rule_1
@onready var rule_2: Label = %Rule_2
@onready var rule_3: Label = %Rule_3
@onready var animation_timer: Timer = %AnimationTimer
@onready var tween: Tween

var showing_rules := true
var is_animating := false

func _ready():
	update_texts()

	animation_timer.wait_time = 6.0
	animation_timer.start()
	
	animation_timer.timeout.connect(_on_animation_timer_timeout)

func update_texts():
	if showing_rules:
		title.text = "Controls"
		rule_1.text = "1. Left click to cycle through icons"
		rule_2.text = "2. Right click to remove symbols"
		rule_3.text = "3. Adjust difficulty in the right side slider , Click Retry to retry level , Next to go next level ! "
		
	else:
		title.text = "Puzzle Rules"
		rule_1.text = "1. Fill the Grid"
		rule_2.text = "2. Each row & column must contain exactly 3 Suns and 3 Moons"
		rule_3.text = "3. No 3 Suns or 3 Moons can appear consecutively in any row or column"

func _on_animation_timer_timeout():
	if is_animating:
		return
		
	is_animating = true
	showing_rules = !showing_rules
	
	if tween:
		tween.kill()
	tween = create_tween()
	tween.set_parallel(true)
	
	tween.tween_property(title, "modulate:a", 0.0, 0.6)
	tween.tween_property(rule_1, "modulate:a", 0.0, 0.6)
	tween.tween_property(rule_2, "modulate:a", 0.0, 0.6)
	tween.tween_property(rule_3, "modulate:a", 0.0, 0.6)
	tween.chain().tween_callback(update_texts)
	tween.tween_property(title, "modulate:a", 1.0, 0.6)
	tween.tween_property(rule_1, "modulate:a", 1.0, 0.6)
	tween.tween_property(rule_2, "modulate:a", 1.0, 0.6)
	tween.tween_property(rule_3, "modulate:a", 1.0, 0.6)
	
	tween.chain().tween_callback(_on_animation_complete)

func _on_animation_complete():
	is_animating = false
