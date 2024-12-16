extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -300.0
const CROUCH_SPEED = 100.0
@onready var ap = $AnimationPlayer
@onready var sprite = $Sprite2D
var is_attacking = false #avoid interrumtions in attack animations and stop movement
var is_crouched = false #flag to determine if player is crouching

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	#handle player crouching
	if Input.is_action_pressed("crouch"):
		crouch()
	if Input.is_action_just_released("crouch"):
		stand()
		
	#handle attack animations
	if Input.is_action_just_pressed("attack"):
		if is_crouched:
			velocity.x = 0
			play_attack_animation("crouch_attack")
		else:
			velocity.x = 0
			play_attack_animation("attack")
	elif Input.is_action_just_pressed("attack 2"): 
		if is_crouched:
			pass
		else:
			velocity.x = 0
			play_attack_animation("attack2")
		
	#stop movement while attacking
	if is_attacking :
		move_and_slide()
		return

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		if is_crouched:
			velocity.x = direction * CROUCH_SPEED
		else:
			velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if (direction != 0):
		sprite.flip_h = (direction == -1)
		
	if Input.is_action_just_pressed("crouch"):
		crouch()
	elif Input.is_action_just_released("crouch"):
		stand()
	if Input.is_action_just_pressed("roll"):
		roll(direction)

	move_and_slide()
	update_animation(direction)

func update_animation(direction):
	if is_attacking:
		move_and_slide()
		return
	if is_on_floor():
		if direction == 0:
			if is_crouched:
				ap.play("crouch")
			else:
				ap.play("idle")
		else:
			if is_crouched:
				ap.play("crouch_walk")
			else:
				ap.play("run")
	else:
		if velocity.y < 0:
			ap.play("jump")
		elif velocity.y > 0:
			ap.play("fall")

func play_attack_animation(attack_type: String) -> void:
	is_attacking = true
	ap.play(attack_type)
	await ap.animation_finished
	is_attacking = false
	
func crouch()-> void:
	if is_crouched:
		return
	else:
		is_crouched = true
		
func stand()-> void:
	if is_crouched:
		is_crouched = false
	else:
		return
		
func roll(direction)-> void:
	if is_crouched or is_attacking:
		return
	if direction != 0:
		print("roll start")
		is_attacking = true
		velocity.x = direction * SPEED * 1.2
		ap.play("roll")
		await ap.animation_finished
		print("roll end")
		is_attacking = false
	else:
		print("no roll - not moving")
