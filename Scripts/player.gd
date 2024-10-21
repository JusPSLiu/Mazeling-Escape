extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -300.0
const LERP_DECAY_RATE = 10

@onready var floorchecker : RayCast2D = $FloorChecker
@onready var clinksound : AudioStreamPlayer2D = $clinksound
@onready var rollsound : AudioStreamPlayer2D = $clinksound/rollsound
@onready var slidesound : AudioStreamPlayer2D = $clinksound/slidesound
@onready var hitground : AudioStreamPlayer2D = $clinksound/hitground

var previousVelocity : Vector2

func _physics_process(delta: float) -> void:
	# Add the gravity.
	var go_to_volume : float = 0
	if not is_on_floor():
		velocity += get_gravity() * delta * 0.3
	elif (abs(velocity.x) < 0.1):
		go_to_volume = 0
	else:
		go_to_volume = clamp(abs(velocity.x)*0.01, 0, 1)
		# play slide sound
		if (floorchecker.is_colliding()):
			# play the special audio player
			slidesound.set_pitch_scale((abs(velocity.x) * 0.001) + 0.8)
			rollsound.set_volume_db(-80)
		else:
			# play the regular audio player
			rollsound.set_pitch_scale((abs(velocity.x) * 0.0005) + 1.3)
			slidesound.set_volume_db(-80)
	
	if (floorchecker.is_colliding() or slidesound.get_volume_db() > -79): slidesound.set_volume_db(linear_to_db(expDecay(db_to_linear(slidesound.get_volume_db()), go_to_volume*0.8, LERP_DECAY_RATE, delta)))
	else: rollsound.set_volume_db(linear_to_db(expDecay(db_to_linear(rollsound.get_volume_db()), go_to_volume, LERP_DECAY_RATE, delta)))
	
	# clink sounds
	var maxVelociDifference = max(abs(velocity.x - previousVelocity.x),
									abs(velocity.y - previousVelocity.y))
	if floorchecker.is_colliding():
		if (maxVelociDifference > 10):
			hitground.set_volume_db(linear_to_db(clamp(maxVelociDifference*0.007, 0, 1)))
			hitground.play()
	else:
		if (maxVelociDifference > 100):
			# play sound
			clinksound.set_pitch_scale(randf_range(0.6,0.8))
			clinksound.set_volume_db(linear_to_db(clamp(maxVelociDifference*0.003, 0, 0.2)))
			clinksound.play()
			pass

	# Handle jump.
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	elif (!Input.is_action_pressed("ui_up") and velocity.y < 0):
		velocity.y += delta*500
	
	previousVelocity = velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = expDecay(velocity.x, direction * SPEED, LERP_DECAY_RATE, delta)
	else:
		velocity.x = expDecay(velocity.x, 0, LERP_DECAY_RATE, delta)

	move_and_slide()

func expDecay(a, b, decay, dt):
	return b+(a-b)*exp(-decay*dt)
