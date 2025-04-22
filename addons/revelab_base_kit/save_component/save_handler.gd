@tool
@icon("res://addons/save_load/icons/save_component.png")
class_name Save_Component
extends Node

#region Signals
signal loading_data(data)
signal saving_data(data)
#endregion

#region Constants
const NODE_GROUP = "Save_Component"
const SAVE_STATE_NODE_PATH = "Save_Component_node_path"
const SAVE_STATE_OWNER_NODE_PATH = "Save_Component_owner_node_path"
const SAVE_STATE_INSTANCE_SCENE = "Save_Component_dynamic_recreate_scene"
const SAVE_STATE_PARENT_FREED = "Save_Component_parent_freed"
#endregion

#region Classes
class SaveFreedInstancedChildScene:
	var id: String
	var node_path: String
	
	func _init(save_id: String, save_node_path: String) -> void:
		id = save_id
		node_path = save_node_path
	
	func save_data(data: Dictionary) -> void:
		var node_data := {}
		data[id] = node_data
		node_data[SAVE_STATE_PARENT_FREED] = true
		node_data[SAVE_STATE_NODE_PATH] = node_path
#endregion

#region Exported Variables
@export var save_properties:Array[String] = []
@export var dynamic_instance := false: set = _set_dynamic_instance
@export var global := false: set = _set_global
@export var debug := false
#endregion

#region Setters
func _set_dynamic_instance(value: bool) -> void:
	if global and value:
		printerr("Save_Component: Dynamic Instance and Global cannot both be true.")
		return
	dynamic_instance = value

func _set_global(value: bool) -> void:
	if dynamic_instance and value:
		printerr("Save_Component: Dynamic Instance and Global cannot both be true.")
		return
	global = value
#endregion

#region Lifecycle Functions
func _enter_tree():
	add_to_group(NODE_GROUP)
	if has_user_signal("instanced_child_scene_freed"):
		return
	add_user_signal("instanced_child_scene_freed", [{"save_freeds_instanced_child_scene_object": TYPE_OBJECT}])

func _exit_tree():
	if dynamic_instance:
		return
	var parent = get_parent()
	var id = Save_Component.get_id(parent)
	var save_freed_object = SaveFreedInstancedChildScene.new(id, id)
	emit_signal("instanced_child_scene_freed", save_freed_object)
#endregion

#region Save & Load Functions
func save_data(data: Dictionary) -> void:
	var parent = get_parent()
	var id = Save_Component.get_id(parent)
	var node_data := {}
	
	if global:
		node_data = data
	else:
		data[id] = node_data
	
	if !parent.owner and !global and parent != get_tree().current_scene:
		node_data[SAVE_STATE_INSTANCE_SCENE] = parent.scene_file_path
	
	if !global:
		node_data[SAVE_STATE_NODE_PATH] = parent.get_path()
		if parent.owner:
			node_data[SAVE_STATE_OWNER_NODE_PATH] = str(parent.owner.get_path())
	
	for prop_name in save_properties:
		node_data[prop_name] = parent.get_indexed(prop_name)
	
	emit_signal("saving_data", node_data)

func load_data(data: Dictionary) -> void:
	var parent = get_parent()
	var id = str(parent.get_path())
	var node_data: Dictionary
	
	if global:
		node_data = data
	elif data.has(id):
		node_data = data[id]
	else:
		emit_signal("loading_data", node_data)
		return
	
	if node_data.has(SAVE_STATE_PARENT_FREED) and node_data[SAVE_STATE_PARENT_FREED]:
		parent.queue_free()
		return
	
	for prop_name in save_properties:
		if node_data.has(prop_name):
			parent.set_indexed(prop_name, node_data[prop_name])
	
	emit_signal("loading_data", node_data)

func set_data(node_data: Dictionary) -> void:
	var parent = get_parent()
	for prop_name in save_properties:
		parent.set(prop_name, node_data[prop_name])
	emit_signal("loading_data", node_data)
#endregion

#region Utility Functions
static func get_id(node:Node) -> String:
	return str(node.get_path()).replace("@", "_")
#endregion
