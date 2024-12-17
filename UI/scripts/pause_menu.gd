extends CanvasLayer

@onready var music_player = $AudioStreamPlayer2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS
	var audio_stream = load("res://Sounds/main_menu.ogg")
	if audio_stream is AudioStream:
		audio_stream.loop = true
		music_player.stream = audio_stream
		music_player.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _input(event):
	if event.is_action_pressed("esc"):
		toogle_pause()

func toogle_pause()-> void:
	if get_tree().paused:
		get_tree().paused = false
		visible = false
	else:
		get_tree().paused = true
		visible = true
		$PauseMenu/VBoxContainer/resume.grab_focus()




func _on_resume_pressed() -> void:
	print("resume pressed")
	toogle_pause()


func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_exit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://UI/scenes/main_menu.tscn")
