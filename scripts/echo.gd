class_name Echo extends CharacterBody3D

@export var echo_data: EchoData

@export var isReplaying: bool = false 

@export var timer: Timer

func _ready() -> void:
	if echo_data != null:
		isReplaying = true

func _physics_process(delta: float) -> void:
	
	if !timer.is_stopped():
		
		visible = true
		get_child(1).disabled = false
		if isReplaying:
			replay_echo()
		move_and_slide()
	else:
		global_position = echo_data.pos[0]
		velocity = Vector3.ZERO
		get_child(1).disabled = true
		visible = false
		#isReplaying = false
		echo_data.iteration = 0
		
func replay_echo():
	if echo_data.iteration == len(echo_data.pos):
		echo_data.iteration = 0
		isReplaying = false
		velocity = Vector3.ZERO
		return
	global_position = echo_data.pos[echo_data.iteration]
	global_rotation = echo_data.rot[echo_data.iteration]
	velocity = echo_data.velocity[echo_data.iteration]
	echo_data.iteration += 1
	return
	
