class_name ElevatorEntity extends Entity

@export var go_to_next: bool = true
@export var section_name: String
@export var level_idx: int
@export var quit: bool = false
@export var entity: Entity
@export var timer: Timer
@export var pos_change: Vector3
var okey_dokey: bool = false

func _ready() -> void:
	entity.connected.connect(on_entity_signal_true)

func _physics_process(delta: float) -> void:
	if okey_dokey:
		print(global_position)
		var tween = get_tree().create_tween()
	
		var pos = global_position+pos_change
		tween.tween_property(self,"global_position",pos,10).set_trans(Tween.TRANS_QUAD)
		
		print("move True")
		okey_dokey = false
		await tween.finished
		#await get_tree().create_timer(5).timeout
		on_entered()

func on_entity_signal_true():
	timer.paused = true
	okey_dokey = true
	connected.emit()
	
	
func on_entered():
	
	if quit: get_tree().quit()
	if go_to_next:
		LevelLoader.next_level.emit()
	else:
		LevelLoader.level_change_by_idx.emit(section_name,level_idx)
