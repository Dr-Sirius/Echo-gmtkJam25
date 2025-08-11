@tool
extends LineEdit
## Plugin: bulkMeshCollisionShapeExporter
## A LineEdit which only accepts Numbers and auto selects all text when editing is toggled on.

var numbers_only_regex: RegEx = RegEx.new()
@onready var old_text: String = text

func _ready() -> void:
	numbers_only_regex.compile("^[0-9]")

func _on_text_changed(new_text: String) -> void:
	if !numbers_only_regex.search(new_text):
		text = old_text
		return


func _on_editing_toggled(toggled_on: bool) -> void:
	if toggled_on:
		call_deferred("select_all")
