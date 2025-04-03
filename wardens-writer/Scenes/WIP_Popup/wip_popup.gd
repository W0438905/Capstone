extends Control

@onready var label_1: Label = $GlobalBackground/MarginContainer/VBoxContainer/Label1
@onready var label_2: Label = $GlobalBackground/MarginContainer/VBoxContainer/Label2
@onready var button: Button = $GlobalBackground/MarginContainer/VBoxContainer/Button


func _ready() -> void:
	label_1.add_theme_font_size_override("font_size", 48)
	label_2.add_theme_font_size_override("font_size", 16)
	button.add_theme_font_size_override("font_size", 24)


func _on_button_pressed() -> void:
	SignalManager.wip_popup.emit(false)
