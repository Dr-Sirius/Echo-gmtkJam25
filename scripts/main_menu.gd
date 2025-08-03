extends Control


@export var settings_btn: Button
@export var settings_panel: SettingsMenu
@export var play_btn: Button
@export var quit_btn: Button

func _ready() -> void:
	settings_btn.button_up.connect(settings_press)
	play_btn.button_up.connect(play_press)
	quit_btn.button_up.connect(get_tree().quit)
	
func settings_press():
	settings_panel.visible = !settings_panel.visible

func play_press():
	LevelLoader.start()
