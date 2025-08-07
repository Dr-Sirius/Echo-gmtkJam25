extends Area3D


@export var go_to_next: bool = true
@export var level_idx: int
@export var quit: bool = false

func _ready() -> void:
	body_entered.connect(on_entered)
	
func on_entered(body: Node3D):
	if body.name == "Player":
		if quit: get_tree().quit()
		LevelLoader.level_change.emit(go_to_next,level_idx)
