extends CanvasLayer

@onready var health_bar = $HealthBar
@onready var message_label = $Label
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func update_health(current_healt: int, max_health: int)-> void:
	health_bar.value = current_healt
	health_bar.max_value = max_health
	
func show_message(text: String):
	message_label.text = text
	message_label.visible = true

func hide_message()-> void:
	message_label.visible = false
	
