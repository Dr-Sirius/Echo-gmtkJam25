extends CSGBox3D

@export var timer: Timer
@export var player: CharacterBody3D



var player_left: bool = false
func _physics_process(delta: float) -> void:
	if timer.is_stopped() and player_left:
		player.global_position.x = global_position.x
		player.global_position.z = global_position.z
		player.global_position.y = global_position.y + 1
		player_left = false
		

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.name.to_lower() == "player":
		player_left = true
		
		timer.start()
