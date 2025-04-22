extends CanvasLayer

signal scene_transitioning(new_scene_path)

@onready var _fade_animation: AnimationPlayer = $fadeAnimation
@onready var is_loading := false

var scene_load_status = 0
var _scene_path := ""
var progress = []


#region Process
func _process(_delta):
	if !is_loading:
		return
	_load_scene()
#endregion

#region Scene Transition
func transition_to(scene_path: String):
	_scene_path = scene_path
	_load()

func _load():
	is_loading = true
	_fade_animation.play("fadeOut")
	get_tree().paused = true
	ResourceLoader.load_threaded_request(_scene_path)

func _load_scene():
	scene_load_status = ResourceLoader.load_threaded_get_status(_scene_path, progress)

	if scene_load_status == ResourceLoader.THREAD_LOAD_LOADED:
		_loaded()
#endregion

#region Scene Loaded
func _loaded():
	var result = ResourceLoader.load_threaded_get(_scene_path)
	scene_transitioning.emit(_scene_path)
	_on_scene_transitioning(_scene_path)
	var results_err_check = get_tree().change_scene_to_packed(result)
	if results_err_check != OK:
		printerr("Transition: could not change to scene '%s'" % _scene_path)
		return
	_reset()
	_fade_animation.play("fadeIn")

func _reset():
	is_loading = false
	get_tree().paused = false
	scene_load_status = 0
	progress = []
#endregion

func _on_scene_transitioning(_new_scene_path:String) -> void:
	Save_Service.on_scene_transitioning(_new_scene_path)
