extends CharacterBody3D


@export var SPEED = 4
const JUMP_VELOCITY = 5.5

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * 0.4
		%Camera3D.rotation_degrees.x -= event.relative.y * 0.3
		%Camera3D.rotation_degrees.x = clamp(
			%Camera3D.rotation_degrees.x, -90, 80
		)
	
	elif event.is_action_pressed("ESC"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _process(_delta):
	if Input.is_action_just_pressed("RMB"):
		get_tree().reload_current_scene()
	elif Input.is_action_pressed("LMB") and %Timer.is_stopped():
		fire()

func _physics_process(delta):
	if Input.is_action_pressed("SPRINT"):
		SPEED = 8
	else:
		SPEED = 4
		
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration
 
	var input_dir = Input.get_vector("A", "D", "W", "S")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func fire():
	const ROUND = preload("uid://5n2dfsbuh4ok")
	var bullet = ROUND.instantiate()
	
	# DON'T add as child of Marker3D
	# %Marker3D.add_child(bullet)  <-- THIS IS THE PROBLEM
	
	# INSTEAD: Add to the root level of the scene
	get_tree().current_scene.add_child(bullet)
	
	# Set position and rotation to match Marker3D
	bullet.global_position = %Marker3D.global_position
	bullet.global_rotation = %Marker3D.global_rotation

	%Timer.start()
