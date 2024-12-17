extends Node2D

@onready var player = $Player  # Nodo del jugador
@onready var hud_scene = preload("res://UI/scenes/hud.tscn")
@onready var music_player = $AudioStreamPlayer2D
var hud

func _ready():
	# Instanciar el HUD y agregarlo a la escena
	hud = hud_scene.instantiate()
	add_child(hud)
	var audio_stream = load("res://Sounds/level.ogg")
	if audio_stream is AudioStream:
		audio_stream.loop = true
		music_player.stream = audio_stream
		music_player.play()
	
	# Pasar el HUD al jugador
	player.set_hud(hud)
