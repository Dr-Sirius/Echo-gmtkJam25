class_name SensorEntity extends Entity


@export var disabled: bool = true
@export var light: OmniLight3D
@export var default_light_color: Color = Color(0.214, 0.404, 1.0)

@export var area: Area3D
@export var entity: Entity
@export var timer: Timer
var isDisabled: bool

func _ready() -> void:
	isDisabled = disabled
	if entity != null:
		entity.connected.connect(on_entity_signal_true)
		entity.disconnected.connect(on_entity_signal_false)
	if timer != null:
		timer.timeout.connect(on_timeout)
	area.body_entered.connect(_on_area_3d_body_entered)
	area.body_exited.connect(_on_area_3d_body_exited)

func _process(delta: float) -> void:
	
	if isDisabled:
		light.light_color = Color(0.881, 0.0, 0.249)
	else:
		light.light_color = default_light_color
		
func on_timeout():
	isDisabled = disabled		
		
func on_entity_signal_true():
	print(name + " is not disabled")
	isDisabled = false	
	
func on_entity_signal_false():
	print(name + " is disabled")
	isDisabled = true			

func _on_area_3d_body_entered(body: Node3D) -> void:
	if !isDisabled and (body is Echo or body.name == "Player"):
		connected.emit()
		light.light_color = Color(0.0, 0.651, 0.287)


func _on_area_3d_body_exited(body: Node3D) -> void:
	if !isDisabled and (body is Echo or body.name == "Player"):
		disconnected.emit()
		light.light_color = default_light_color
