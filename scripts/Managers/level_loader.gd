extends Node


var levels: Array[LevelSectionInfo]
var current_section: LevelSectionInfo
var current_level: PackedScene


signal level_change(next_in_line:bool,level_index:int)

func _init() -> void:

	level_change.connect(change_level)
	
	
	


func change_level(next:bool,  level_id: String):
	print("changing")
	
	#if next and current_level_n < len(levels["Fracture"].keys()):
		#current_level_n += 1
		#
		#get_tree().change_scene_to_packed(levels[current_level])
	#elif !next:
		#current_level = level_id
		#get_tree().change_scene_to_packed(levels[level_id])

# pulled from https://www.reddit.com/r/godot/comments/k1t53k/getting_tscn_children_from_levels_folder/
func get_file_paths_by_extension(dir_path: String, extension: String, recursive: bool = true) -> Array:
	var dir := DirAccess.open(dir_path)
	if dir == null:
		printerr("Warning: Could not open: ", dir_path)
		return []
	
	if dir.list_dir_begin() != OK:
		printerr("Warning: Could not list contents of: ", dir_path)
		return []
	
	var file_paths: Array = []
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
		change_level(false,save["level"])
	else:
		change_level(false,0)
	
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
		
		

		
