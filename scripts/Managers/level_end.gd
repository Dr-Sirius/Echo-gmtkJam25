extends Area3D


@export var go_to_next: bool = true
@export var section_name: String
@export var level_idx: int
@export var quit: bool = false

func _ready() -> void:
	body_entered.connect(on_entered)
	
func on_entered(body: Node3D):
	if body.name == "Player":
		if quit: get_tree().quit()
		if go_to_next:
			LevelLoader.next_level.emit()
		else:
			LevelLoader.level_change_by_idx.emit(section_name,level_idx)
