class_name AudioHSlider
extends HSlider

## The name of the Audio Bus to edit
@export var bus_name : StringName = "Master"
var bus_idx : int = 0


func _init() -> void:
	min_value = 0.0
	max_value = 1.0
	step = 0.01
	#exp_edit = true


func _ready() -> void:
	bus_idx = AudioServer.get_bus_index(bus_name)
	if bus_idx == -1:
		self_modulate.a = 0.5
		return
	
	value = db_to_linear(AudioServer.get_bus_volume_db(bus_idx))
	value_changed.connect(_on_value_changed)


func _on_value_changed(new_value) -> void:
	var new_volume = linear_to_db(new_value)
	AudioServer.set_bus_volume_db(bus_idx, new_volume)
