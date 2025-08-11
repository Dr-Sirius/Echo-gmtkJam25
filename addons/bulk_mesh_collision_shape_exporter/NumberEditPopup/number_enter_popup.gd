@tool
class_name NumberEnterPopup
extends Popup
## Plugin: bulkMeshCollisionShapeExporter

signal number_entered(number: int)

@onready var _value_changer: ValueChanger = $HBoxContainer/MarginContainer

## Sets the value the NumberEnterPopup will display upon loading.
##
## If this is never called the displayed value will be 0.
func initialize_value_when_ready(current_value: int):
	call_deferred("_initilize_value", current_value)

func _initilize_value(current_value: int):
	_value_changer.h_slider.value = current_value

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action("ui_accept"):
		number_entered.emit(_value_changer.h_slider.value)
		queue_free()


func _on_popup_hide() -> void:
	number_entered.emit(_value_changer.h_slider.value)
	queue_free()
