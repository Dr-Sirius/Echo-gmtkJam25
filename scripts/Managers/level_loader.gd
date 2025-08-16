extends Node


var levels_sections: Array[LevelSectionInfo]
var current_section: LevelSectionInfo
var current_level: PackedScene
var current_level_index: int

signal level_change_by_idx(section:String, level_idx: int)
signal next_level

func _init() -> void:
	
	level_change_by_idx.connect(change_level_by_idx)
	next_level.connect(chnage_to_next_level)
	levels_sections = get_file_paths_by_extension("res://scenes/Levels/","tres",false)
	current_section = levels_sections[0]
	current_level = current_section.levels[0]
	current_level_index = 0
	
func change_level_by_idx(section: String, level_idx:int):
	print("changing")
	current_level_index = level_idx
	
	if current_section.section_name == section:
		current_level = current_section.levels[level_idx]
		get_tree().change_scene_to_packed(current_section.levels[level_idx])
		return
	
	for i in levels_sections:
		if i.section_name == section:
			current_section = i
	
	current_level = current_section.levels[level_idx]
	
func chnage_to_next_level():
	
	if current_level_index + 1 >  len(current_section.levels):
		for i in range(len(levels_sections)):
			if levels_sections[i].section_name == current_section.section_name:
				if len(levels_sections) - 1 == i:
					change_level_by_idx("Fracture",0)
				else:
					change_level_by_idx(levels_sections[i+1].section_name,0)
	else:
		current_level_index+=1
		change_level_by_idx(current_section.section_name,current_level_index)	

# pulled from https://www.reddit.com/r/godot/comments/k1t53k/getting_tscn_children_from_levels_folder/
func get_file_paths_by_extension(dir_path: String, extension: String, recursive: bool = true) -> Array[LevelSectionInfo]:
	var dir := DirAccess.open(dir_path)
	if dir == null:
		printerr("Warning: Could not open: ", dir_path)
		return []
	
	if dir.list_dir_begin() != OK:
		printerr("Warning: Could not list contents of: ", dir_path)
		return []
	
	var file_paths: Array[LevelSectionInfo] = []
	var file_name: String = dir.get_next()
	
	while file_name != "":
		if dir.current_is_dir():
			if recursive:
				var current_dir_path = dir.get_current_dir() + "/" + file_name
				file_paths += get_file_paths_by_extension(current_dir_path,extension,recursive)
		
		else:
			
			if file_name.get_extension().contains(extension):
				var file_path = dir.get_current_dir() + "/" + file_name
				file_paths.append(load(file_path))
			elif file_name.get_extension().contains("remap"):
				file_name = file_name.replace('.remap', '') 
				var file_path = dir.get_current_dir() + "/" + file_name
				file_paths.append(load(file_path))
				
		
		file_name = dir.get_next()
		
	return file_paths

func start():
	print("load")
	var save = load_game()
	print(save)
	if !save.is_empty():
		print("loading level")
		change_level_by_idx(save["section"],save["level_idx"])
	else:
		change_level_by_idx("Fracture",0)
	
func load_game() -> Dictionary:
	if not FileAccess.file_exists("user://savegame.save"):
		return {}
	

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()

		# Creates the helper class to interact with JSON.
		var json = JSON.new()
	
		# Check if there is any error while parsing the JSON string, skip in case of failure.
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue
		
		return json.data
	return {}
		
		

		
