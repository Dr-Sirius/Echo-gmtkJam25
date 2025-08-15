class_name LightEntity extends Entity



@export var deactivated_light_color: Color = Color(0.902, 0.133, 0.106)
@export var active_light_color: Color = Color(0.483, 0.755, 0.0)
@export var entity: Entity



func _ready() -> void:
	if entity != null:
		entity.connected.connect(on_entity_signal_true)
		entity.disconnected.connect(on_entity_signal_false)
		

func on_entity_signal_true():
	self.light_color = active_light_color
	
func on_entity_signal_false():
	self.light_color = deactivated_light_color
