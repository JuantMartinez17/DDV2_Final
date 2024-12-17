extends Control

@onready var popup_panel = $PopupPanel
@onready var label_group = $PopupPanel/MarginContainer/Label
@onready var grid_container = $VBoxContainer/GridContainer
@onready var label_popup = $PopupPanel/MarginContainer/Label
var action_to_reassign = ""
var controls_file_path = "user://controls.json"
var awaiting_input = false

var action_buttons = {
	"move_left": null,
	"move_right": null,
	"jump": null,
	"attack": null,
	"attack_2": null,
	"crouch": null,
	"roll": null,
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_buttons()

func _process(delta: float) -> void:
	pass

func setup_buttons()-> void:
	for action in action_buttons:
		var button = Button.new()
		button.text = _get_action_key_string(action)
		button.pressed.connect(_on_action_button_pressed.bind(action, button))
		action_buttons[action] = button
		grid_container.add_child(button)

func _on_action_button_pressed(action, button)-> void:
	action_to_reassign = action
	label_popup.text = "Press a key to assing '%s'" % action
	popup_panel.visible()
	awaiting_input = true

func _input(event):
	if awaiting_input and event is InputEventKey and event.pressed:
		awaiting_input = false
		popup_panel.visible = false
		
		InputMap.action_erase_events(action_to_reassign)
		InputMap.action_add_event(action_to_reassign, event)
		
		action_buttons[action_to_reassign].text = event.as_text()
		print("Acción '%s' reasignada a %s" % [action_to_reassign, event.as_text()])

func _get_action_key_string(action):
	var events = InputMap.action_get_events(action)
	if events.size() > 0:
		return events[0].as_text()
	else:
		return "N/A"
		

func _on_save_pressed() -> void:
	var config = {}
	for action in action_buttons.keys():
		var events = InputMap.action_get_events(action)
		if events.size() > 0: 
			config[action] = events[0].as_text()
	save_config_to_file(config)
	
func save_config_to_file(config)-> void:
	var file = FileAccess.open("user://input_config.cfg", FileAccess.WRITE)
	for action in config.keys():
		file.store_line("%s=%s" % [action, config[action]])
	file.close()
	print("config saved")

func _on_restore_pressed() -> void:
	for action in action_buttons.keys():
		InputMap.action_erase_events(action)
		var default_event = InputEventKey.new()
		match action:
			"move_left": default_event.keycode = KEY_A
			"move_right": default_event.keycode = KEY_D
			"jump": default_event.keycode = KEY_W
			"attack": default_event.keycode = KEY_X
			"attack_2": default_event.keycode = KEY_C
			"crouch": default_event.keycode = KEY_CTRL
			"roll": default_event.keycode = KEY_R
		InputMap.action_add_event(action, default_event)
		action_buttons[action].text = default_event.as_text()
	print("Configuración restaurada.")
