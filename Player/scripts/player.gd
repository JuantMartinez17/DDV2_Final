extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -300.0
const CROUCH_SPEED = 100.0
var damage = 25
@onready var ap = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var attack_area = $Area2D
var is_attacking = false #avoid interrumtions in attack animations and stop movement
var is_crouched = false #flag to determine if player is crouching
var max_health = 100
var current_health: int = max_health
var is_dead: bool = false
var hud: CanvasLayer
var enemies_in_range = []

func set_hud(hud_instance: CanvasLayer)-> void:
	hud = hud_instance
	
func _physics_process(delta: float) -> void:
	if is_dead:
		return
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
			damage = 20
			play_attack_animation("crouch_attack")
		else:
			velocity.x = 0
			play_attack_animation("attack")
		attack_enemies_in_range(damage)
	elif Input.is_action_just_pressed("attack2"): 
		if is_crouched:
			pass
		else:
			velocity.x = 0
			damage = 30
			play_attack_animation("attack2")
		attack_enemies_in_range(damage)
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
		
func take_damage(amount: int)-> void:
	if is_dead:
		return
	current_health -= amount
	if current_health <= 0:
		current_health = 0
		die()
	else:
		on_damage_taken()
	hud.update_health(current_health, max_health)

func die()-> void:
	is_dead = true
	print("You died!")
	ap.play("death")
	velocity = Vector2.ZERO
	get_tree().change_scene_to_file("res://UI/scenes/game_over_menu.tscn")

func heal(amount: int)-> void:
	if is_dead:
		return
	elif current_health == 100:
		return
	else:
		current_health += amount
		if current_health > max_health:
			current_health = max_health

func on_damage_taken()-> void:
	print("damage taken")
	ap.play("hit")
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body != self and body is CharacterBody2D:
		enemies_in_range.append(body)
		print(enemies_in_range)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body in enemies_in_range:
		enemies_in_range.erase(body)
		
func attack_enemies_in_range(damage)-> void:
	for enemy in enemies_in_range:
		if enemy is CharacterBody2D and not enemy.is_dead:
			enemy.take_damage(damage)
