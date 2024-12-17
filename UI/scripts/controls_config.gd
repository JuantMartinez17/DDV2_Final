extends Control

@onready var popup_panel = $PopupPanel
@onready var label_popup = $PopupPanel/MarginContainer/Label
@onready var grid_container = $VBoxContainer/GridContainer
@onready var save_button = $VBoxContainer/HBoxContainer/save
@onready var restore_button = $VBoxContainer/HBoxContainer/restore

var action_to_reassign = ""
var awaiting_input = false

# Mapeo de acciones con sus descripciones
var action_buttons = {
	"move_left": "Move Left",
	"move_right": "Move Right",
	"jump": "Jump",
	"attack": "Attack",
	"attack2": "Attack 2",
	"crouch": "Crouch",
	"roll": "Roll"
}

func _ready() -> void:
	# Crear botones dinámicamente y asignarles acciones
	for action in action_buttons.keys():
		var button = Button.new()
		button.text = action_buttons[action]
		button.theme = load("res://Themes/menu_button.tres")  # Aplicar el tema al botón
		
		# Usar bind() para pasar el 'action' al método
		button.connect("pressed", _on_action_button_pressed.bind(action))
		
		# Añadir el botón al GridContainer o VBoxContainer
		grid_container.add_child(button)

	save_button.grab_focus()  # Foco inicial en el botón Save

func _on_action_button_pressed(action) -> void:
	action_to_reassign = action
	label_popup.text = "Press a key to assign '%s'" % action.capitalize()
	popup_panel.visible = true
	awaiting_input = true

func _input(event):
	if awaiting_input and event is InputEventKey and event.pressed:
		awaiting_input = false
		popup_panel.visible = false
		
		# Actualizar el mapa de entradas con la nueva tecla
		InputMap.action_erase_events(action_to_reassign)
		InputMap.action_add_event(action_to_reassign, event)
		
		# Imprimir un mensaje con la tecla asignada
		print("Acción '%s' reasignada a %s" % [action_to_reassign, event.as_text()])

func _on_save_pressed() -> void:
	var config = {}
	for action in action_buttons.keys():
		var events = InputMap.action_get_events(action)
		if events.size() > 0: 
			config[action] = events[0].as_text()
	save_config_to_file(config)

func save_config_to_file(config) -> void:
	var file = FileAccess.open("user://input_config.cfg", FileAccess.WRITE)
	for action in config.keys():
		file.store_line("%s=%s" % [action, config[action]])
	file.close()
	print("Configuración guardada.")
	print(config)
	

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
		
	print("Configuración restaurada.")

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/scenes/main_menu.tscn")
