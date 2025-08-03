extends CSGCylinder3D

signal disrupted
signal clear

@export var disabled: bool = true
@export var light: OmniLight3D
@export var default_light_color: Color = Color(0.214, 0.404, 1.0)

@export var button: Node3D

func _ready() -> void:
	button.connect("pressed",on_entity_signal_true)
	button.connect("released",on_entity_signal_false)

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
		disrupted.emit()
		light.light_color = Color(0.0, 0.651, 0.287)


func _on_area_3d_body_exited(body: Node3D) -> void:
	if !disabled and body is not CSGPrimitive3D:
		clear.emit()
		light.light_color = default_light_color
