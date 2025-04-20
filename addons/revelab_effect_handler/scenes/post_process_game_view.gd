@tool
extends TextureRect


func _ready() -> void:
	var vp_text = get_node("../../Distort_View/Sub_Viewport").get_texture()
	var s_mat = material as ShaderMaterial
	s_mat.set_shader_parameter("displacement_mask", vp_text)
