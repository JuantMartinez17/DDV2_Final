extends CharacterBody2D

const SPEED = 120.0
const JUMP_VELOCITY = -400.0
@export var max_health: int = 200
@export var damage: int = 20
@export var speed: float = SPEED
@export var detection_range: float = 600.0
@onready var ap = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var detection_area = $DetectionArea2D
@onready var attack_area = $AttackArea2D

var current_health: int = max_health
var is_dead: bool = false
var is_chasing: bool = false
var is_attacking: bool = false
var player: CharacterBody2D = null

func _physics_process(delta: float) -> void:
	if is_dead: 
		return

	if is_chasing and not is_attacking:
		var direction_to_player = (player.global_position - global_position).normalized()
		sprite.flip_h = direction_to_player.x < 0
		velocity.x = direction_to_player.x * SPEED
		ap.play("run")
	else:
		velocity.x = 0
	move_and_slide()

func take_damage(amount: int) -> void:
	if is_dead:
		return
	current_health -= amount
	if current_health <= 0:
		current_health = 0
		die()
	else:
		on_damage_taken()

func on_damage_taken() -> void:
	ap.play("hit")

func die() -> void:
	is_dead = true
	velocity = Vector2.ZERO
	ap.play("death")
	await ap.animation_finished
	queue_free()

func attack(player) -> void:
	if is_attacking or is_dead:
		return
	is_attacking = true
	ap.play("attack")
	await ap.animation_finished
	is_attacking = false
	player.take_damage(damage)

func _on_detection_area_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		player = body
		is_chasing = true


func _on_detection_area_2d_body_exited(body: Node2D) -> void:
	if body == player:
		player = null
		is_chasing = false


func _on_attack_area_2d_body_entered(body: Node2D) -> void:
	if body == player:
		is_chasing = false
		attack(player)


func _on_attack_area_2d_body_exited(body: Node2D) -> void:
	if body == player:
		is_chasing = true
