extends Control

@export var timer_info: Label
@export var loop_info: Label
@export var settings_panel: SettingsMenu

@export var Pause_Menu: Control
@export var Resume: Button
@export var Settings: Button
@export var Save: Button
@export var Quit: Button

var timer: Timer
var pemanager: Node3D
var isCaptured: bool
var paused: bool
var settings_vis: bool

func _ready() -> void:
	timer = get_tree().current_scene.get_node("Timer")
	pemanager = get_tree().current_scene
	
	Resume.pressed.connect(resume)
	Save.pressed.connect(save)
	Settings.pressed.connect(settings_show)
	Quit.pressed.connect(get_tree().quit)

func _unhandled_input(event: InputEvent) -> void:
	
	if Input.is_action_just_pressed("ui_cancel"):
		
		if paused: 
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			resume()
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE 
			pause()
		
		
	
func _process(delta: float) -> void:
	timer_info.text = "Time Left: " + str(snapped(timer.time_left,0.01))
	loop_info.text = "Loop " + str(pemanager.loop_count + 1) + " // " + str(pemanager.loop_max)
	

func pause():
	paused = true
	timer_info.hide()
	loop_info.hide()
	Pause_Menu.show()

func resume():
	paused = false
	timer_info.show()
	loop_info.show()
	Pause_Menu.hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func settings_show():
	if settings_vis:
		settings_panel.hide()
		settings_vis  = false
	else:
		settings_vis = true
		settings_panel.show()

func save():
	
	var save_data: Dictionary = {
		"level": LevelLoader.current_level
	}
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)

	# JSON provides a static method to serialized JSON string.
	var json_string = JSON.stringify(save_data)

	# Store the save dictionary as a new line in the save file.
	save_file.store_line(json_string)
