extends Node

@onready var top_label: Label = $GlobalBackground/MarginContainer/VBoxContainer/TopLabel
@onready var required_label: Label = $GlobalBackground/MarginContainer/VBoxContainer/RequiredLabel
@onready var title_line: LineEdit = $GlobalBackground/MarginContainer/VBoxContainer/Title/TitleLine
@onready var author_line: LineEdit = $GlobalBackground/MarginContainer/VBoxContainer/Author/AuthorLine
@onready var description_box: TextEdit = $GlobalBackground/MarginContainer/VBoxContainer/Description/MarginContainer/DescriptionBox
@onready var button_spacer: Control = $GlobalBackground/MarginContainer/VBoxContainer/ButtonSpacer


func _ready() -> void:
	top_label.add_theme_font_size_override("font_size", 32)
	required_label.add_theme_font_size_override("font_size", 10)
	required_label.add_theme_color_override("font_color", Color.DARK_RED) # set to ab000d later


func reset_text_boxes() -> void:
	title_line.text = ""
	author_line.text = ""
	description_box.text = ""
	required_label.add_theme_font_size_override("font_size", 10)
	required_label.text = "*Required"
	button_spacer.visible = true


func _on_confirm_button_pressed() -> void:
	if title_line.text.is_empty():
		required_label.add_theme_font_size_override("font_size", 16)
		required_label.text = "*Story Must Have Title"
		button_spacer.visible = false
	else:
		# if not, take info in bars and time snippet and send it to database
		var title: String = title_line.text
		var author: String = author_line.text
		var desc: String = description_box.text
		var create_date: String = StoryManager.get_date()
		var update_date: String = StoryManager.get_date()
		
		# Write query
		var query: String = "INSERT INTO Stories (title, author, description, createdAt, updatedAt) 
		VALUES (?, ?, ?, ?, ?);"
		var params: Array = [title, author, desc, create_date, update_date]
		
		# Send to database
		DatabaseManager.db.query_with_bindings(query, params)
		
		# Emit signal that popup should close
		SignalManager.story_create_popup.emit(false)
		# Set all boxes and top label back to default
		reset_text_boxes()


func _on_cancel_button_pressed() -> void:
	SignalManager.story_create_popup.emit(false)
	reset_text_boxes()
