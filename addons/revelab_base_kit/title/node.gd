extends Node

@export var SYMBOL_COLORS : Dictionary[Node, Color]= {}


func _ready():
	_set_initial_colors()


func _set_initial_colors():
	var i : int = 0
	for node : Node in SYMBOL_COLORS:
		var shader : ShaderMaterial = node.get("material") as ShaderMaterial
		#region safety checks
		if not shader:
			return
		if not shader.get("shader"):
			return
		#endregion safety checks
		
		shader.set_shader_parameter("end_color",SYMBOL_COLORS.get(node))
		shader.set_shader_parameter("start_offset", i * 0.6)
		shader.set_shader_parameter("speed", 1.2)
		i += 1
