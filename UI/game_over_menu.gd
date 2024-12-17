extends Node2D

@onready var music_player = $AudioStreamPlayer2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var audio_stream = load("res://Sounds/game_over.ogg")
	if audio_stream is AudioStream:
		audio_stream.loop = true
		music_player.stream = audio_stream
		music_player.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
