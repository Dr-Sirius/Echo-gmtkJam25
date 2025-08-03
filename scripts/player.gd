extends CharacterBody3D

# PreLoad
@onready var gravity: float =  ProjectSettings.get_setting("physics/3d/default_gravity")

@export var speed: float = 5
@export var jumps: int
@export var jump_height: float
@export var head: Node3D
@export var camera: Camera3D
# Exports/Sensitivities
@export var cam_sens: float = 0.05
# Export/Speed
@export var air_move_speed:float = 600.0
# Export/HeadBob
@export var headbob_movement: float = 0.06
@export var headbob_frequency: float = 2.4
@export var headbob_amplitude: float = 0.0005
# Export/Acceleration
@export var air_accel: float = 800.0
@export var ground_accel: float = 14.0
# Export/Misc
@export var ground_decel: float = 10.0
@export var ground_friction: float = 6.0
@export var air_cap: float = 0.85
@export var auto_behop: bool = true

# Variables
var is_captured: bool = false
var headbob_time: float = 0.0

var isCaptured: bool = false
var desire_dir: Vector3 = Vector3.ZERO
var jump_velocity: int

var can_d_jump: bool = true
var number_jumps: int
var base_speed: float = 7
var sprint_speed: float = 9:
	set(n):
		if n <= base_speed:
			sprint_speed = base_speed + 0.1
		else:
			sprint_speed = n
			
var current_speed: float = base_speed
func _ready():
	
	is_captured = true
	base_speed = speed
	jump_velocity = jump_height
	velocity.y = 0
	
	

	
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and isCaptured:
		isCaptured = false
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif event.is_action_pressed("ui_cancel") and !isCaptured:
		isCaptured = true
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if event is InputEventMouseMotion and isCaptured:
		rotate_y(deg_to_rad(-event.relative.x * cam_sens))
		camera.rotate_x(deg_to_rad(-event.relative.y * cam_sens))
		camera.rotation.x = clamp(camera.rotation.x,deg_to_rad(-60),deg_to_rad(60))
		
func _process(delta: float) -> void:
	pass
		
	#test code
	#if ray.is_colliding() and Input.is_action_just_pressed("record"):
		#var myMesh = MeshInstance3D.new()
		#myMesh.mesh = BoxMesh.new()
		#myMesh.global_position = ray.get_collision_point()
		#get_tree().current_scene.add_child(myMesh)
		
		
	
func _physics_process(delta: float) -> void:
	
	current_speed = base_speed if !Input.is_action_pressed("move_sprint") else sprint_speed
	
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back").normalized()
	desire_dir = global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)
	
	if is_on_floor():
		
		handle_ground_physics(delta)
		
		#handle_ground_dash(delta)
	else:
		handle_air_physics(delta)
		
		#handle_air_dash(delta)
	
	interact_with_rigidbody()
	move_and_slide()
	
func handle_ground_physics(delta) -> void:
	if (Input.is_action_just_pressed("jump") or (auto_behop and Input.is_action_pressed("jump"))) and jumps != 0:
		velocity.y += jump_velocity
		number_jumps += 1
		can_d_jump = true
	
	var cur_speed_in_d_dir: float = velocity.dot(desire_dir)
	var add_speed_untill_cap = current_speed - cur_speed_in_d_dir
	if add_speed_untill_cap > 0:
		var accel_speed = ground_accel * delta * current_speed
		accel_speed = min(accel_speed,add_speed_untill_cap)
		velocity += accel_speed * desire_dir
	
	var control_decel: float = max(velocity.length(),ground_decel)
	var drop_decel: float = control_decel * ground_friction * delta
	var new_speed:float = max(velocity.length() - drop_decel, 0.0)
	if velocity.length() > 0:
		new_speed /= velocity.length()
	velocity *= new_speed
	
	headbob(delta)
	
func handle_air_physics(delta) -> void:
	velocity.y -= gravity * delta
	
	if Input.is_action_just_pressed("jump") and can_d_jump and jumps > 1:
		velocity.y += jump_velocity
		
		number_jumps += 1
		if number_jumps >= jumps:
			can_d_jump = false
			number_jumps = 0
		
			
	
	var cur_speed_in_d_dir: float = velocity.dot(desire_dir)
	var capped_speed = min((air_move_speed * desire_dir).length(), air_cap)
	var add_speed_untill_cap = capped_speed - cur_speed_in_d_dir
	
	if add_speed_untill_cap > 0:
		var accel_speed = air_accel * air_move_speed * delta
		accel_speed = min(accel_speed,add_speed_untill_cap)
		velocity += accel_speed * desire_dir
	
func handle_ground_dash(delta):
	var cur_speed_in_d_dir: float = velocity.dot(desire_dir)
	var add_speed_untill_cap = current_speed - cur_speed_in_d_dir
	#if Input.is_action_just_pressed("move_dash") and dash_timer.is_stopped():
		#
		#dash_timer.start()
		#var accel_speed = ground_accel * delta * current_speed
		#accel_speed = min(accel_speed,add_speed_untill_cap)
		#velocity += (accel_speed * desire_dir * (current_speed/3) * 20) 
		
	

func handle_air_dash(delta):
	var cur_speed_in_d_dir: float = velocity.dot(desire_dir)
	var capped_speed = min((air_move_speed * desire_dir).length(), air_cap)
	var add_speed_untill_cap = capped_speed - cur_speed_in_d_dir
	
	#if Input.is_action_just_pressed("move_dash") and dash_timer.is_stopped():
		#dash_timer.start()
		#var accel_speed = air_accel * air_move_speed * delta
		##accel_speed = min(accel_speed,add_speed_untill_cap)
		#velocity += accel_speed * desire_dir * (current_speed/6) * 0.001 

func headbob(delta):
	headbob_time += delta * velocity.length()
	var headbob_x: float = cos(headbob_time * headbob_frequency * 0.5) * headbob_movement
	var headbob_y: float = sin(headbob_time * headbob_frequency) * headbob_movement + 0.5
	camera.transform.origin = Vector3(headbob_x,headbob_y,0)
	
	

func interact_with_rigidbody():
	var push_force: float = 4.0
	for i in get_slide_collision_count():
		var collider := get_slide_collision(i).get_collider()
		var collider_normal := get_slide_collision(i).get_normal()
		if collider is RigidBody3D:
			collider.apply_central_impulse(-collider_normal * push_force)
		
			
			
