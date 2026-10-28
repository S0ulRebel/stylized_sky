@tool
extends EditorPlugin
## Registers this addon's custom visual shader nodes so they appear in the
## shader editor's Add menu. Add a node script to NODES and it shows up there.

const NODES: Array[String] = []

var _loaded: Array[Script] = []


func _enter_tree() -> void:
	for path in NODES:
		var script := load(path) as Script
		if script == null:
			push_warning("stylized_sky: missing node script %s" % path)
			continue
		add_custom_type(script.get_global_name(), "VisualShaderNodeCustom", script, null)
		_loaded.append(script)


func _exit_tree() -> void:
	for script in _loaded:
		remove_custom_type(script.get_global_name())
	_loaded.clear()
