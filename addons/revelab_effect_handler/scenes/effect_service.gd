extends Node

@export var camera : Camera2D
@onready var sub_viewport: SubViewport = %Sub_Viewport


func _ready() -> void:
	Object_Registry.register_distortion_parent(sub_viewport)
	setup_distortion_camera()

func setup_distortion_camera() -> void:
	var distort_camera := camera.duplicate()
	Object_Registry.register_distortion_effect(distort_camera)
