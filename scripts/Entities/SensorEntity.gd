class_name SensorEntity extends Entity


@export var disabled: bool = true
@export var light: OmniLight3D
@export var default_light_color: Color = Color(0.214, 0.404, 1.0)

@export var entity: Entity

func _ready() -> void:
	entity.connected.connect(on_entity_signal_true)
	entity.disconnected.connect(on_entity_signal_false)


func _process(delta: float) -> void:
	
	if disabled:
		light.light_color = Color(0.881, 0.0, 0.249)
	else:
		light.light_color = default_light_color
		
func on_entity_signal_true():
	disabled = false	
	
func on_entity_signal_false():
	disabled = true			

func _on_area_3d_body_entered(body: Node3D) -> void:
	if !disabled and body is not CSGPrimitive3D:
		connected.emit()
		light.light_color = Color(0.0, 0.651, 0.287)


func _on_area_3d_body_exited(body: Node3D) -> void:
	if !disabled and body is not CSGPrimitive3D:
		disconnected.emit()
		light.light_color = default_light_color
