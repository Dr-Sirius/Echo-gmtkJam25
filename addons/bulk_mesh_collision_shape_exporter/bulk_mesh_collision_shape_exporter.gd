@tool
extends EditorPlugin
## Plugin: bulkMeshCollisionShapeExporter

var _bulk_export_menu: BulkMeshToCollisionExportButton = preload("uid://b4x4htbgd804h").instantiate()

func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	EditorInterface.get_selection().selection_changed.connect(_on_selection_changed)
	add_control_to_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_MENU, _bulk_export_menu)
	_bulk_export_menu.undo_redo = get_undo_redo()


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	remove_control_from_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_MENU, _bulk_export_menu)

func _on_selection_changed():
	if _are_node_3ds_selected():
		_bulk_export_menu.visible = true
	else:
		_bulk_export_menu.visible = false

## Returns true if any of the currently selected Nodes inherit from Node3D.
func _are_node_3ds_selected()-> bool:
	var editor_selection = EditorInterface.get_selection()
	for selected_node: Node in editor_selection.get_selected_nodes():
		if selected_node is Node3D:
			return true
	return false
