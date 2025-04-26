extends Node

@onready var pop: AudioStreamPlayer = $pop


func play_pop():
	pop.pitch_scale = randf_range(0.95, 1.05)
	pop.play()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse"):
		play_pop()
