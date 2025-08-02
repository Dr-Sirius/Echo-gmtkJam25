extends Node3D

@onready var Echo_file = preload("res://scenes/Entities/echo.tscn")

@export var timer: Timer
@export var player: CharacterBody3D
var isRecording: bool = false


var current_echo: EchoData

func _physics_process(delta: float) -> void:
	
	if !isRecording:
		if !timer.is_stopped():
			print("start record")
			var new_echo_data = EchoData.new()
			new_echo_data.pos.append(player.global_position)
			new_echo_data.rot.append(player.global_rotation)
			new_echo_data.velocity.append(player.velocity)
			current_echo = new_echo_data
			
			isRecording = true
		
			
	else:
		if timer.is_stopped():
			print("stop record")
			isRecording = false
			var new_echo = Echo_file.instantiate()
			
			new_echo.echo_data = current_echo
			new_echo.timer = timer
			add_child(new_echo)
			new_echo.global_position = current_echo.pos[0]
			current_echo = null
		else:
			
			current_echo.pos.append(player.global_position)
			current_echo.rot.append(player.global_rotation)
			current_echo.velocity.append(player.velocity)



	
