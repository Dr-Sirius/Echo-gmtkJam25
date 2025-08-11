@tool
class_name BulkMeshToCollisionExportButton
extends MenuButton
## Plugin: bulkMeshCollisionShapeExporter


## Constants refering to the ids of the different items the MenuButton uses
const _EXPORT_COLLISON_SHAPES_ID := 0
const _GENERAL_SEARCH_DEPTH_ID := 1
const _MESH_SEARCH_DEPTH_ID := 2
const _SIMPLIFY_SHAPES_ID := 3

## Undo Redo Manager
var undo_redo: EditorUndoRedoManager

## Specifies how far away a children can be until it will no longer be included in the export
var _setting_mesh_child_search_depth: int = 999_999_999
## Specifies how far away a children can be until it will no longer be included in the export only counting Nodes of type `MeshInstance3D
var _setting_general_child_search_depth: int = 999_999_999
## Simplifys the generated Collision Shapes for better performance when true.
var _setting_simplify_convex_shapes: bool = false


func _ready() -> void:
	get_popup().id_pressed.connect(_on_icon_pressed)
	get_popup().hide_on_checkable_item_selection = false
	_set_tooltips()


## Sets toooltips for all the items
func _set_tooltips() -> void: #Im sure there is a more elegant way to do this. But I was to lazy to figure it out.
	get_popup().set_item_tooltip(_EXPORT_COLLISON_SHAPES_ID, "Export the collision shapes with the  configured settings.")
	get_popup().set_item_tooltip(_GENERAL_SEARCH_DEPTH_ID, "Specifies how far away a children can be until it will no longer be included in the export.")
	get_popup().set_item_tooltip(_MESH_SEARCH_DEPTH_ID, "Specifies how far away a children can be until it will no longer be included in the export only counting Nodes of type `MeshInstance3D`.")
	get_popup().set_item_tooltip(_SIMPLIFY_SHAPES_ID, "Simplifys the generated Collision Shapes for better performance")


## Called when Pressed
func _export_collision_shapes() -> void:
	_generate_static_bodys()


## Generates StaticBodys for all selected Objects.
##
## Childrens of selected Objects will also be used if the Settings specify so.
func _generate_static_bodys()-> void:
	var added_bodys: Dictionary[MeshInstance3D, StaticBody3D]
	var editor_selection: EditorSelection = EditorInterface.get_selection()
	var handled_nodes: Array[Node3D]
	for selected_node: Node in editor_selection.get_selected_nodes():
		if (
				selected_node is Node3D
				and  not handled_nodes.has(selected_node)
		):
			added_bodys = _generate_static_body3d_for_node(selected_node)
			handled_nodes.append(selected_node)
	if added_bodys.size() > 0:
		_create_undo_redo_event(added_bodys)


## Generate StaticBody3ds fitting the mesh for a given Node and its children.
##
## Returns a Dictionary with the Meshinstance that the 
func _generate_static_body3d_for_node(node: Node3D) -> Dictionary[MeshInstance3D, StaticBody3D]:
	var added_shapes: Dictionary[MeshInstance3D, StaticBody3D]
	for mesh: MeshInstance3D in _get_meshes_for(
			node,
			_setting_general_child_search_depth,
			_setting_mesh_child_search_depth
	):
		var added_body: StaticBody3D = _export_collision_shapes_for_mesh(mesh)
		if added_body:
			added_shapes[mesh] = added_body
	return added_shapes


## Returns all Meshes related to a node.
##
## Will return the Node itself if it is a MeshInstance3D
## Does not work for any Meshes that do not inherit from MeshInstance3D
## Will use the Settings given to this Class, this means that
## Depending on the search depth it will not always find all meshes in
## the Children.
func _get_meshes_for(
		node: Node,
		general_search_depth: int,
		mesh_serach_depth: int,
) -> Array[MeshInstance3D]:
	var _meshes: Array[MeshInstance3D]
	if (
			mesh_serach_depth < 0
			or general_search_depth < 0
	):
		return _meshes
	
	if node is MeshInstance3D:
		_meshes.append(node)
		mesh_serach_depth -= 1
	
	for child: Node in node.get_children():
		_meshes.append_array(
				_get_meshes_for(
						child,
						general_search_depth - 1,
						mesh_serach_depth
						)
				)
	
	return _meshes


## Generates a StaticBody3D as a child of the given Mesh with a fitting CollisionShape
##
## Returns the generated StaticBodys.
## If there is already a StaticBody following the default namin Conventions (mesh.name + "_col")
## no additional StaticBody will be generated
func _export_collision_shapes_for_mesh(mesh: MeshInstance3D) -> StaticBody3D:
	var _current_children: Array[Node] = mesh.get_children()
	for child in mesh.get_children():
		if (
				child is StaticBody3D
				and  child.name == mesh.name + "_col"
		):
			push_warning("There already is a Static Body on ", child.name, "(", child, ")")
			return
	mesh.create_convex_collision(true, _setting_simplify_convex_shapes)
	for child in mesh.get_children():
		if (
				not child in _current_children
				and  child is StaticBody3D
		):
			return child
	push_error("StaticBody was deleted right after creating it")
	return


## Creates an undo_redo event that adds/removes the generated Bodys.
func _create_undo_redo_event(added_bodys: Dictionary[MeshInstance3D, StaticBody3D]):
	undo_redo.create_action("bulkMeshCollisionShapeExporter: Exported Collision Shapes")
	undo_redo.add_do_method(self, "_do_add_bodys_by_mesh", added_bodys)
	undo_redo.add_undo_method(self, "_undo_remove_meshes_by", added_bodys)
	undo_redo.commit_action(false)


## Adds the given Meshes to the given Staticbodys.
##
## Relationship is specified by the dictonary.
## (Which mesh belongs to which Staticbody)
func _do_add_bodys_by_mesh(mesh_body: Dictionary[MeshInstance3D, StaticBody3D]):
	for mesh: MeshInstance3D in mesh_body.keys():
		if mesh and  mesh_body[mesh]:
			mesh.add_child(mesh_body[mesh])
			mesh_body[mesh].owner = get_tree().edited_scene_root
			for child in mesh_body[mesh].get_children():
				child.owner = get_tree().edited_scene_root


func _undo_remove_meshes_by(mesh_body: Dictionary[MeshInstance3D, StaticBody3D]):
	for mesh: MeshInstance3D in mesh_body.keys():
		mesh.remove_child(mesh_body[mesh])


## Called when the Popup is about to popup.
##
## Used here to make sure the Checkboxes match the current settings.
## The non Checkbox menues update themself and theirfore do not have to be modified here.
func _on_about_to_popup() -> void:
	if _setting_simplify_convex_shapes != get_popup().is_item_checked(3):
		get_popup().toggle_item_checked(3)


func _on_icon_pressed(id: int) -> void:
	if get_popup().is_item_checkable(id):
		match id:
			_SIMPLIFY_SHAPES_ID:
				get_popup().toggle_item_checked(3) # toggle the checkbox
				_setting_simplify_convex_shapes = get_popup().is_item_checked(id) # Update the setting
				return
	match id:
		_EXPORT_COLLISON_SHAPES_ID:
			_export_collision_shapes()
		_GENERAL_SEARCH_DEPTH_ID:
			_instatiate_num_popup(id, _setting_general_child_search_depth)
		_MESH_SEARCH_DEPTH_ID:
			_instatiate_num_popup(id, _setting_mesh_child_search_depth)


## Creates a new [NumberEnterPopup] that displayes the given value.
func _instatiate_num_popup(id: int, value: int):
	var new_popup: NumberEnterPopup = preload("uid://bnam3oxlx0kay").instantiate()
	new_popup.initialize_value_when_ready(value)
	add_child(new_popup)
	new_popup.show()
	new_popup.position = get_global_mouse_position()
	new_popup.number_entered.connect(_update_setting_to.bind(id))


## Changes the setting with the given id to the given value.
func _update_setting_to(new_value: int, setting_id: int):
	match setting_id:
		_GENERAL_SEARCH_DEPTH_ID:
			_setting_general_child_search_depth = new_value
		_MESH_SEARCH_DEPTH_ID:
			_setting_mesh_child_search_depth = new_value
