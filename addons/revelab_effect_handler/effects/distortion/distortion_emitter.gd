
extends GPUParticles2D

@onready var timer := $Timer
var is_dying := false


func activate() -> void:
	one_shot = true
	emitting = true


func _process(_delta: float) -> void:
	if not emitting and not is_dying:
		die()


func die() -> void:
	is_dying = true
	timer.start(lifetime)
	await timer.timeout
	queue_free()
