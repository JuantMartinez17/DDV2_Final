extends CharacterBody2D


const SPEED = 180.0
const JUMP_VELOCITY = -400.0
@export var max_health: int = 50
@export var damage: int = 15
@export var speed: float = SPEED
@onready var ap = $AnimationPlayer
@onready var sprite = $Sprite

var current_health: int = max_health
var is_dead: bool = false
var is_attacking: bool = false


func _physics_process(delta: float) -> void:
	if is_dead: 
		return
	
	velocity.x = 0
	move_and_slide()
	
func take_damage(amount: int)-> void:
	if is_dead:
		return
	current_health -= amount
	if current_health <= 0:
		current_health = 0
		die()
	else:
		on_damage_taken()

func on_damage_taken()-> void:
	ap.play("hit")
	
func die()-> void:
	is_dead = true
	velocity = Vector2.ZERO
	ap.play("death")
	await ap.animation_finished
	queue_free()
	
func attack(player)-> void:
	if is_attacking or is_dead:
		return
	is_attacking = true
	ap.play("attack")
	await ap.animation_finished
	is_attacking = false
	player.take_damage(damage)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		print("Jugador detectado. atacando...")
		attack(body)
