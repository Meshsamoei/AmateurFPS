extends Area3D

const SPEED = 100
const RANGE = 400


var travelled_range = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position += -transform.basis.z * SPEED * delta
	travelled_range += SPEED * delta
	print(travelled_range)
	if travelled_range > RANGE:
		queue_free()
