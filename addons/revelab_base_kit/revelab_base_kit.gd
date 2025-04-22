@tool
extends EditorPlugin



#save_service.gd
const SAVE_SERVICE_PATH = "res://addons/revelab_base_kit/auto_loads/save_service.gd"
const SAVE_SERVICE_AUTO_LOAD_NAME = "Save_Service"

##save_bridge.gd
#const SAVE_BRIDGE_PATH = "res://addons/revelab_base_kit/auto_loads/save_bridge.gd"
#const SAVE_BRIDGE_AUTO_LOAD_NAME = "Save_Bridge"
#

#transition_manager.tscn
const TRANSITION_SERVICE_PATH = "res://addons/revelab_base_kit/auto_loads/transition_manager.tscn"
const TRANSITION_SERVICE_AUTO_LOAD_NAME = "Transition_Manager"


func _enable_plugin() -> void:
	add_autoload_singleton(SAVE_SERVICE_AUTO_LOAD_NAME, SAVE_SERVICE_PATH)
	#add_autoload_singleton(SAVE_BRIDGE_AUTO_LOAD_NAME, SAVE_BRIDGE_PATH)
	add_autoload_singleton(TRANSITION_SERVICE_AUTO_LOAD_NAME, TRANSITION_SERVICE_PATH)


func _disable_plugin() -> void:
	remove_autoload_singleton(SAVE_SERVICE_AUTO_LOAD_NAME)
	#remove_autoload_singleton(SAVE_BRIDGE_AUTO_LOAD_NAME)
	remove_autoload_singleton(TRANSITION_SERVICE_AUTO_LOAD_NAME)
