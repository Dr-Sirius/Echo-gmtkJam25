extends CSGBox3D


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("test_plat"):
		global_position.y += 10
