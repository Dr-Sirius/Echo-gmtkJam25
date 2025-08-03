class_name WallEnity extends Entity

@export var entity: Entity
@export var timer: Timer
@export var up_y: float = 3.0
var default_y: float = position.y

func _ready() -> void:
	if entity != null:
		entity.connected.connect(on_entity_signal_true)
		entity.disconnected.connect(on_entity_signal_false)
		
	timer.timeout.connect(reset)
	
func reset():
	position.y = default_y
	
func on_entity_signal_true():
	var tween = get_tree().create_tween()
	var pos = Vector3(position.x,position.y + up_y,position.z)
	tween.tween_property(self,"position",pos,0.4)
	connected.emit()
	
func on_entity_signal_false():
	position.y = default_y
	disconnected.emit()
