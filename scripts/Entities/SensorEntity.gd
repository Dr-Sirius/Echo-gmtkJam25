class_name SensorEntity extends Entity


@export var disabled: bool = true
@export var light: OmniLight3D
@export var default_light_color: Color = Color(0.0, 0.746, 0.591)
@export var enabled_light_color: Color = Color(0.856, 0.38, 0.0)
@export var disabled_light_color: Color = Color(0.791, 0.0, 0.125)
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

#func _process(delta: float) -> void:
	#
	#if isDisabled:
		#light.light_color = disabled_light_color
	#else:
		#light.light_color = enabled_light_color
		
func on_timeout():
	isDisabled = disabled		
		
func on_entity_signal_true():
	print(name + " is not disabled")
	isDisabled = false	
	light.light_color = enabled_light_color
	
	
func on_entity_signal_false():
	print(name + " is disabled")
	isDisabled = true			
	light.light_color = disabled_light_color

func _on_area_3d_body_entered(body: Node3D) -> void:
	if !isDisabled and (body is Echo or body.name == "Player"):
		connected.emit()
		light.light_color = default_light_color


func _on_area_3d_body_exited(body: Node3D) -> void:
	if !isDisabled and (body is Echo or body.name == "Player"):
		disconnected.emit()
		light.light_color = enabled_light_color
