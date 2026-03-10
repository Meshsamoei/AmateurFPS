extends RigidBody3D

var hp = 3
var speed = randf_range(2.0, 4.0)
var vertical_speed = 1.5
var hover_height = 1.5  # How high above player to hover
var is_dead = false  # Add a death flag

@onready var animation_player = $bat_model/AnimationPlayer
@onready var bat_model = %bat_model
@onready var player = get_node("/root/Game/Player")
@onready var timer = %Timer

func _physics_process(delta):
	if not player or is_dead:  # Check death flag
		return
	
	# Calculate target position (player's position + hover offset)
	var target_pos = player.global_position
	target_pos.y += hover_height  # Bat hovers above player
	
	# Get direction to target
	var direction = global_position.direction_to(target_pos)
	
	# Apply velocity
	linear_velocity = direction * speed
	
	# Make the bat model ALWAYS look at the player
	look_at_player()
	
	# Add flapping animation
	animate_bat(delta)

func look_at_player():
	if not player or is_dead:  # Check death flag
		return
	
	# Calculate direction to player (ignore vertical for rotation if you want)
	var look_dir = (player.global_position - bat_model.global_position).normalized()
	
	# Option B: Look at player but keep model upright (only rotate around Y axis)
	var horizontal_dir = Vector3(look_dir.x, 0, look_dir.z).normalized()
	if horizontal_dir.length() > 0:
		bat_model.rotation.y = Vector3.FORWARD.signed_angle_to(horizontal_dir, Vector3.UP) + PI

func animate_bat(delta):
	if is_dead:  # Check death flag
		return
		
	# Simple wing flap based on vertical movement
	var vertical_movement = abs(linear_velocity.y) * 2.0
	bat_model.rotation.x = sin(Time.get_time_dict_from_system().second * 10) * 0.2 * vertical_movement
func take_damage():
	if hp <= 0 or is_dead:
		return
	
	bat_model.hurt()
	hp -= 1
	
	if hp == 0:
		is_dead = true
		animation_player.stop()

		# Disable all processing
		set_physics_process(false)
		set_process(false)
		
		# Disable the bat model's processing
		bat_model.set_process(false)
		bat_model.set_physics_process(false)
		
		# Hide any particles or effects
		# %Particles.emitting = false
		
		# Apply death impulse
		gravity_scale = 1.0
		var direction = player.global_position.direction_to(global_position)
		var random_upward_force = Vector3.UP * randf() * 5.0
		apply_central_impulse(direction.rotated(Vector3.UP, randf_range(-0.2, 0.2)) * 10.0 + random_upward_force)
		
		timer.start()
		
func _on_timer_timeout():
	queue_free()
