class_name WallEntity extends Entity

@export var entity: Entity
@export var timer: Timer
@export var pos_change: Vector3 = Vector3(0,3,0)
@export var tween_out: bool = false
@export var on: bool = false
var default_pos: Vector3


func _ready() -> void:
	default_pos = position
	if on:
		
		on_entity_signal_true()
	if entity != null:
		entity.connected.connect(on_entity_signal_true)
		entity.disconnected.connect(on_entity_signal_false)
	
	if timer != null:
		timer.timeout.connect(on_entity_signal_false)

func _process(delta: float) -> void:
	if timer:
		if timer.is_stopped() and !on:
			position = default_pos

func on_entity_signal_true():
	var tween = get_tree().create_tween()
	var pos = position + pos_change
	tween.tween_property(self,"position",pos,0.4)
	
		
	
func on_entity_signal_false():
	if tween_out:
		var tween = get_tree().create_tween()
		
		tween.tween_property(self,"position",default_pos,0.4)
	else:
		position = default_pos
	disconnected.emit()
