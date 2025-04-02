extends HBoxContainer

@onready var plus_sign: Label = $HBoxContainer/PlusSign
@onready var create_button: Button = $HBoxContainer/CreateButton

const FONT_SIZE: int = 32


func _ready() -> void:
	plus_sign.add_theme_font_size_override("font_size", FONT_SIZE)
	create_button.add_theme_font_size_override("font_size", FONT_SIZE)


func _process(_delta: float) -> void:
	pass


func _on_create_button_pressed() -> void:
	SignalManager.note_create_popup.emit(true)
