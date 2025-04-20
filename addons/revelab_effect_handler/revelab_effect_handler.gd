@tool
extends EditorPlugin




#save_service.gd
const OBJECT_REGISTERY_PATH = "res://addons/revelab_effect_handler/auto_load/object_registry.tscn"
const OBJECT_REGISTERY_AUTOLOAD_NAME = "Object_Registry"


const EFFECT_CATALOG_PATH = "res://addons/revelab_effect_handler/auto_load/effect_catalog.tscn"
const EFFECT_CATALOG_AUTOLOAD_NAME = "Effect_Catalog"


func _enable_plugin() -> void:
	add_autoload_singleton(OBJECT_REGISTERY_AUTOLOAD_NAME, OBJECT_REGISTERY_PATH)
	add_autoload_singleton(EFFECT_CATALOG_AUTOLOAD_NAME, EFFECT_CATALOG_PATH)

func _disable_plugin() -> void:
	remove_autoload_singleton(OBJECT_REGISTERY_AUTOLOAD_NAME)
	remove_autoload_singleton(EFFECT_CATALOG_AUTOLOAD_NAME)
