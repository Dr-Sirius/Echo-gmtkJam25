extends CSGBox3D


signal pressed
signal released


@export var pressed_y: float = 0.1
@export var disabled: bool = false
var down: bool = false

func _on_area_3d_body_entered(body: Node3D) -> void:
	if !down and body is not CSGPrimitive3D:
		print(position)
		position.y -= pressed_y
		down = true
		pressed.emit()


func _on_area_3d_body_exited(body: Node3D) -> void:
	if down and body is not CSGPrimitive3D:
		print(position)
		position.y += pressed_y
		down = false
		released.emit()
