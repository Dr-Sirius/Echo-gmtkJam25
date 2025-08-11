@tool
class_name ValueChanger
extends Control
## Plugin bulkMeshCollisionShapeExporter
##
## Parent to input methods that allow to change values.
## Contains References to the Value Changing input handlers

var line_edit: LineEdit
var h_slider: HSlider

func _ready() -> void:
	line_edit = $LineEdit
	h_slider = $HSlider
	line_edit.edit()

## Make sure the line_edit value matches the new h_slider value.
func _on_h_slider_value_changed(value: float) -> void:
	if line_edit.text != str(int(value)):
		line_edit.text = str(int(value))

## Make sure the h_slider value matches the new line_edit value.
func _on_line_edit_text_changed(new_text: String) -> void:
	if h_slider.value != int(new_text):
		h_slider.value = int(new_text)
		h_slider.update_max_value()
