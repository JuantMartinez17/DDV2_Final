extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_key_config()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Levels/scenes/level1.tscn")
	

func _on_exit_pressed() -> void:
	get_tree().quit()
	
func _on_controls_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/scenes/controls_config.tscn")
	
func load_key_config()-> void:
	var file_path = "user://input_config.cfg"
	if FileAccess.file_exists(file_path):
		var file = FileAccess.open(file_path, FileAccess.READ)
		if file:
			while not file.eof_reached():
				var line = file.get_line()
				if line == "":
					continue
				var parts = line.split("=")
				if parts.size() == 2:
					var action = parts[0]
					var key_string = parts [1]
					var event = InputEventKey.new()
					event.keycode = OS.find_keycode_from_string(key_string)
					InputMap.action_erase_events(action)
					InputMap.action_add_event(action, event)
			file.close()
			print("key bindings loaded")
		else:
			print("File not found")
					
				
