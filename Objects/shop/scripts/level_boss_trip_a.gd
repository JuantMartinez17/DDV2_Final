extends Area2D

@onready var destination = get_tree().root.get_node("Level1/level_boss_trip_B")
@onready var hud = get_tree().root.get_node("Level1/Hud")

var player_in_area = false
var player = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event):
	if player_in_area and event.is_action_pressed("travel"):
		teleport_player()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_in_area = true
		player = body
		hud.show_message("Press E to fight final boss")
		print("Presiona enter para viajar")


func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player_in_area = false
		player = null
		hud.hide_message()

func teleport_player():
	if destination and player:
		player.global_position = destination.global_position
		hud.hide_message()
		print("Teletransportado a: ", destination.name)
