extends Control

@onready var write_button: TextureButton = $CanvasLayer/MarginContainer/VBoxContainer/Write

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	write_button.scale = Vector2(1.5, 1.5)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
