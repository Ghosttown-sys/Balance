extends Node

@onready var pop: AudioStreamPlayer = $pop
@onready var error_sound: AudioStreamPlayer = $ErrorSound


func play_pop() -> void:
	pop.play()


func play_error() -> void:
	error_sound.play()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse"):
		play_pop()
