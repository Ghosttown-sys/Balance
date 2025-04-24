extends Node

@onready var moon: Sprite2D = $Moon
@onready var rain: Sprite2D = $Rain
@onready var snow: Sprite2D = $Snow
@onready var sun: Sprite2D = $Sun
@onready var thunder: Sprite2D = $Thunder
@onready var wind: Sprite2D = $Wind

var SYMBOL_COLORS := {
	"moon": Color("#a4d6f8"),
	"sun": Color("#ffd965"),
	"rain": Color("#00bfff"),
	"snow": Color("#00f0ff"),
	"thunder": Color("#bf40bf"),
	"wind": Color("#7fffd4")
}

var tween: Tween

func _ready():
	_set_initial_colors()
	_start_color_pulse_animation()

func _set_initial_colors():
	moon.modulate = SYMBOL_COLORS["moon"]
	rain.modulate = SYMBOL_COLORS["rain"]
	snow.modulate = SYMBOL_COLORS["snow"]
	sun.modulate = SYMBOL_COLORS["sun"]
	thunder.modulate = SYMBOL_COLORS["thunder"]
	wind.modulate = SYMBOL_COLORS["wind"]

func _start_color_pulse_animation():
	if tween:
		tween.kill()
	
	tween = create_tween()
	tween.set_loops()
	
	tween.set_parallel(true)
	
	_pulse_symbol(moon, "moon", randf_range(0.1, 0.5))
	_pulse_symbol(sun, "sun", randf_range(0.1, 0.5))
	_pulse_symbol(rain, "rain", randf_range(0.1, 0.5))
	_pulse_symbol(snow, "snow", randf_range(0.1, 0.5))
	_pulse_symbol(thunder, "thunder", randf_range(0.1, 0.5))
	_pulse_symbol(wind, "wind", randf_range(0.1, 0.5))

func _pulse_symbol(sprite: Sprite2D, color_key: String, initial_delay: float):
	var duration = randf_range(1.5, 2.5)
	var delay = randf_range(1.0, 2.0)
	
	tween.tween_property(sprite, "modulate", Color.WHITE, duration)\
		.set_ease(Tween.EASE_IN_OUT)\
		.set_delay(initial_delay)
	
	tween.tween_property(sprite, "modulate", SYMBOL_COLORS[color_key], duration)\
		.set_ease(Tween.EASE_IN_OUT)\
		.set_delay(initial_delay + duration + delay)
