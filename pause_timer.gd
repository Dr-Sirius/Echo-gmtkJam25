extends Area3D

@export var timer: Timer

func _ready() -> void:
	body_entered.connect(on_enter)
	
	
func on_enter(body: Node):
	if (body is Echo or body.name == "Player"):
		timer.paused = true
