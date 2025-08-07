extends Control


@export var settings_btn: Button
@export var option_menu: Control
@export var play_btn: Button
@export var quit_btn: Button

func _ready() -> void:
	settings_btn.button_up.connect(settings_press)
	play_btn.button_up.connect(play_press)
	quit_btn.button_up.connect(get_tree().quit)
	
func settings_press():
	option_menu.visible = !option_menu.visible
	pass
	
func play_press():
	LevelLoader.start()
