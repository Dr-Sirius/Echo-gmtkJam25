@tool
extends EditorScript

func _run():
	var current_scene = get_scene()
	if not current_scene:
		print("No scene is currently open.")
		return
	
	#var export_path = current_scene.scene_file_path.get_base_dir() + "/exported_areas/"
	var export_path = "res://assets/libraries/" + current_scene.name + "/"
	var dir = DirAccess.open(export_path)
	if not dir:
		DirAccess.make_dir_absolute(export_path)
	
	for child in current_scene.get_children():
		if child is Node3D and child.visible:
			var packed_scene = PackedScene.new()
			
			# Create a new Node3D to act as the root for our exported scene
			var root = Node3D.new()
			root.name = child.name
			
			# Duplicate the Area3D and its entire hierarchy
			var duplicated_area:Node3D = child.duplicate(Node.DUPLICATE_GROUPS | Node.DUPLICATE_SCRIPTS | Node.DUPLICATE_SIGNALS)
			duplicated_area.position = Vector3(0, 0, 0)
			root.add_child(duplicated_area)
			duplicated_area.owner = root
			
			# Recursively set owner for all children
			for descendant in duplicated_area.get_children():
				set_owner_recursive(descendant, root)
			
			packed_scene.pack(root)
			var save_path = export_path + child.name + ".tscn"
			var error = ResourceSaver.save(packed_scene, save_path)
			if error == OK:
				print("Exported: " + save_path)
			else:
				print("Failed to export: " + child.name)
	
	print("Export complete. Files saved to: " + export_path)

func set_owner_recursive(node: Node, new_owner: Node):
	node.owner = new_owner
	for child in node.get_children():
		set_owner_recursive(child, new_owner)
