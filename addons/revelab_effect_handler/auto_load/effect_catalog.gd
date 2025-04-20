@tool
extends Node

#region Predefined Effects
enum Effect_Name {
	RIPPLE,
	SHOCKWAVE,
	DISTORTION,
}

@export var effects: Dictionary = {
	Effect_Name.RIPPLE: preload("res://addons/revelab_effect_handler/effects/ripple/ripple_emitter.tscn"),
	Effect_Name.SHOCKWAVE: preload("res://addons/revelab_effect_handler/effects/shock_wave/shockwave_emitter.tscn"),
	Effect_Name.DISTORTION: preload("res://addons/revelab_effect_handler/effects/distortion/distortion_emitter.tscn"),
}

#endregion


#region Varaibles
var effect_templates: Dictionary = {}
#endregion

#region Ready Function
func _ready() -> void:
	for effect_type in effects.keys():
		var scene: PackedScene = effects[effect_type]
		var instance := scene.instantiate()
		if instance is GPUParticles2D:
			effect_templates[effect_type] = instance
		else:
			push_error("❌ Effect '%s' is not a GPUParticles2D node!" % str(effect_type))
#endregion

#region Play Effect Function
func play_effect(effect_type: Variant, position: Vector2) -> void:
	if effect_type is int:
		var effect_name = effect_type

		if not effect_templates.has(effect_name):
			push_warning("⚠️ Effect '%s' template not found!" % str(effect_name))
			return

		var instance := effect_templates[effect_name].duplicate() as GPUParticles2D
		instance.global_position = position
		instance.emitting = true

		match effect_name:
			Effect_Name.RIPPLE, Effect_Name.SHOCKWAVE, Effect_Name.DISTORTION:
				Object_Registry.register_distortion_effect(instance)
			_:
				Object_Registry.register_effect(instance)

		if instance.has_method("activate"):
			instance.activate()
		elif instance.has_node("LifeSpan"):
			instance.get_node("LifeSpan").start()
#endregion

#region Add New Effect Function
func add_new_effect(name: Variant, scene: PackedScene) -> void:
	var effect_name: String = ""

	if name is int:
		effect_name = str(Effect_Name.values()[name])
	elif name is String:
		effect_name = name
	else:
		push_warning("⚠️ Invalid effect name type.")
		return

	if effect_name in effects:
		push_warning("⚠️ Effect '%s' already exists!" % effect_name)
		return

	effects[effect_name] = scene
	var instance = scene.instantiate()
	if instance is GPUParticles2D:
		effect_templates[effect_name] = instance
	else:
		push_error("❌ Scene for '%s' is not a GPUParticles2D!" % effect_name)

	print("✅ New effect '%s' registered successfully!" % effect_name)

#endregion
