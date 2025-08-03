extends CSGBox3D



@export var button: Node3D
@export var sensor: Node3D
@export var timer: Timer
@export var up_y: float = 3.0
var default_y: float = position.y

func _ready() -> void:
	if button != null:
		button.connect("pressed",on_entity_signal_true)
		button.connect("released",on_entity_signal_false)
	if sensor != null:
		sensor.connect("disrupted",on_entity_signal_true)
		sensor.connect("clear",on_entity_signal_false)
		
	timer.timeout.connect(reset)
	
func reset():
	position.y = default_y
	
func on_entity_signal_true():
	var tween = get_tree().create_tween()
	var pos = Vector3(position.x,position.y + up_y,position.z)
	tween.tween_property(self,"position",pos,0.4)
	
func on_entity_signal_false():
	position.y -= up_y
