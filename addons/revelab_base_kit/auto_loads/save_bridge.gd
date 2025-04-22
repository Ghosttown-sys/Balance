extends Node

func _ready() -> void:
	if OK != Transition_Manager.scene_transitioning.connect(_on_scene_transitioning):
		printerr("save_bridge: failed connect to scene_transitioning")


func _on_scene_transitioning(_new_scene_path:String) -> void:
	Save_Service.on_scene_transitioning(_new_scene_path)
