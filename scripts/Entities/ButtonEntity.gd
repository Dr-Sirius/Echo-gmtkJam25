class_name ButtonEntity extends Entity

@export var pressed_y: float = 0.1
@export var disabled: bool = false
@export var area: Area3D
var pressed: bool = false

func _ready() -> void:
	if area:
		area.body_entered.connect(_on_area_3d_body_entered)
		area.body_exited.connect(_on_area_3d_body_exited)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if !pressed and body is not CSGPrimitive3D:
		print(position)
		position.y -= pressed_y
		pressed = true
		connected.emit()


func _on_area_3d_body_exited(body: Node3D) -> void:
	if pressed and body is not CSGPrimitive3D:
		print(position)
		position.y += pressed_y
		pressed = false
		disconnected.emit()
