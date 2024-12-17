extends Area2D

@onready var hud = get_tree().root.get_node("Level1/Hud")
var player_in_area = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	player_in_area = true
	hud.show_message("Press E to complete the level")


func _on_body_exited(body: Node2D) -> void:
	player_in_area = false
	hud.hide_message()

func _input(event):
	if player_in_area and event.is_action_pressed("travel"):
		get_tree().change_scene_to_file("res://UI/scenes/level_completed.tscn")
