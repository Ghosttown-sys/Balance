extends Node

func _ready() -> void:
	var mouse_pos = Vector2(9999,9999)
	Effect_Catalog.play_effect(Effect_Catalog.Effect_Name.SHOCKWAVE, mouse_pos)
	Effect_Catalog.play_effect(Effect_Catalog.Effect_Name.RIPPLE, mouse_pos)
	Effect_Catalog.play_effect(Effect_Catalog.Effect_Name.DISTORTION, mouse_pos)
