extends Node


var levels: Array[PackedScene]

var current_level: int = 1

signal level_change(next_in_line:bool,level_index:int)

func _ready() -> void:
	level_change.connect(change_level)
	levels = get_file_paths_by_extension("res://scenes/Levels/","tscn")
	for i in levels:
		print(i.resource_path)


func change_level(next:bool,  level_id: int):
	print("changing")
	
	if next and current_level < len(levels):
		current_level += 1
		
		get_tree().change_scene_to_packed(levels[current_level])
	elif !next:
		get_tree().change_scene_to_packed(levels[level_id])

# pulled from https://www.reddit.com/r/godot/comments/k1t53k/getting_tscn_children_from_levels_folder/
func get_file_paths_by_extension(dir_path: String, extension: String, recursive: bool = true) -> Array[PackedScene]:
	var dir := DirAccess.open(dir_path)
	if dir == null:
		printerr("Warning: Could not open: ", dir_path)
		return []
	
	if dir.list_dir_begin() != OK:
		printerr("Warning: Could not list contents of: ", dir_path)
		return []
	
	var file_paths: Array[PackedScene] = []
	var file_name: String = dir.get_next()
	
	while file_name != "":
		if dir.current_is_dir():
			if recursive:
				var current_dir_path = dir.get_current_dir() + "/" + file_name
				file_paths += get_file_paths_by_extension(current_dir_path,extension,recursive)
		
		else:
			if file_name.get_extension() == extension:
				var file_path = dir.get_current_dir() + "/" + file_name
				file_paths.append(load(file_path))
		
		file_name = dir.get_next()
		
	return file_paths
