extends Node2D

@onready var player = $Player  # Nodo del jugador
@onready var hud_scene = preload("res://UI/scenes/hud.tscn")
var hud

func _ready():
	# Instanciar el HUD y agregarlo a la escena
	hud = hud_scene.instantiate()
	add_child(hud)
	
	# Pasar el HUD al jugador
	player.set_hud(hud)
