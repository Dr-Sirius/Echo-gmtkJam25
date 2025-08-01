class_name Echo extends CharacterBody3D

@export var echo_data: EchoData

@export var isReplaying: bool = false 

func _ready() -> void:
	if echo_data != null:
		isReplaying = true

func _physics_process(delta: float) -> void:
	if isReplaying:
		replay_echo()
	move_and_slide()

func replay_echo():
	print(echo_data.iteration)
	

	if echo_data.iteration == len(echo_data.pos):
		echo_data.iteration = 0
		isReplaying = false
		velocity = Vector3.ZERO
		return
	#global_position = echo_data.pos[echo_data.iteration]
	global_rotation = echo_data.rot[echo_data.iteration]
	velocity = echo_data.velocity[echo_data.iteration]
	echo_data.iteration += 1
	return
	
