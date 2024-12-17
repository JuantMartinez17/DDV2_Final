extends Area2D

@onready var hud = get_tree().root.get_node("Level1/Hud")
var player = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
		if body is CharacterBody2D:
			player = body
			player.heal(100)
			hud.show_message("Health points restored. FIGHT!")
	
