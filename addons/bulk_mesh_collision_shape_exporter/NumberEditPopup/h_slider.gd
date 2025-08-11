@tool
extends HSlider
## Plugin: bulkMeshCollisionShapeExporter
## A slider that updates its maxvalue if the value is greater than it.

@onready var _default_value: int = max_value


func update_max_value():
	if value > _default_value:
		max_value = value
	else:
		max_value = _default_value

func _on_value_changed(value: float) -> void:
	if value > max_value:
		max_value = value


func _on_drag_ended(value_changed: bool) -> void:
	if value_changed:
		update_max_value()
