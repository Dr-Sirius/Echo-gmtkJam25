extends Node3D

@onready var Echo_file = preload("res://echo.tscn")

@export var player: CharacterBody3D
var isRecording: bool = false


var echoes: Array[EchoRecording]

var current_echo: EchoRecording


func _physics_process(delta: float) -> void:
	record()

func record():
	
	if !isRecording:
		if Input.is_action_just_pressed("record"):
			print("record")
			isRecording = !isRecording
			var new_echo = Echo_file.instantiate()
			var new_echo_rec: EchoRecording = EchoRecording.new(player.global_position,new_echo)
			current_echo = new_echo_rec
			
			echoes.append(new_echo_rec)
	else:
		print(current_echo.positions)
		if Input.is_action_just_pressed("record"):
			print("stop record")
			isRecording = !isRecording
			add_child(current_echo.echo)
			current_echo.LoopPos()
		else: 
			current_echo.AddPos(player.global_position)

class EchoRecording extends Node:
	var positions: Array[Vector3]
	var echo: Echo
	var timer: Timer
	
	func _init(pos: Vector3,echo: Echo) -> void:
		self.positions = [pos]
		self.echo = echo
		self.timer = Timer.new()
		get_tree().current_scene.add_child(timer)
		
		

	func AddPos(pos: Vector3) -> void:
		self.positions.append(pos)
	
	func SetPos(pos: Vector3) -> void:
		self.echo.global_position = pos
	
	func LoopPos() -> void:
		for p in positions:
			self.SetPos(p)
			self.timer.start(1)
			await self.timer.timeout
			
		
