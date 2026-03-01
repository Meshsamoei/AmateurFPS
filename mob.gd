extends RigidBody3D

var speed = randf_range(2.0, 4.0)
var vertical_speed = 1.5
var hover_height = 1.5  # How high above player to hover

@onready var bat_model = %bat_model
@onready var player = get_node("/root/Game/Player")

func _physics_process(delta):
	if not player:
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
	if not player:
		return
	
	# Calculate direction to player (ignore vertical for rotation if you want)
	var look_dir = (player.global_position - bat_model.global_position).normalized()
	
	# Option A: Look at player with full 3D rotation (might tilt weirdly)
	# bat_model.look_at(bat_model.global_position + look_dir, Vector3.UP)
	
	# Option B: Look at player but keep model upright (only rotate around Y axis)
	var horizontal_dir = Vector3(look_dir.x, 0, look_dir.z).normalized()
	if horizontal_dir.length() > 0:
		bat_model.rotation.y = Vector3.FORWARD.signed_angle_to(horizontal_dir, Vector3.UP) + PI
	
	# Option C: Smooth rotation (uncomment if you want gradual turning)
	# var target_rotation = Vector3.FORWARD.signed_angle_to(horizontal_dir, Vector3.UP)
	# bat_model.rotation.y = lerp_angle(bat_model.rotation.y, target_rotation, 0.1)

func animate_bat(delta):
	# Simple wing flap based on vertical movement
	var vertical_movement = abs(linear_velocity.y) * 2.0
	bat_model.rotation.x = sin(Time.get_time_dict_from_system().second * 10) * 0.2 * vertical_movement

func take_damage():
	bat_model.hurt()
