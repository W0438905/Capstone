extends Node

@onready var top_label: Label = $GlobalBackground/MarginContainer/VBoxContainer/TopLabel
@onready var required_label: Label = $GlobalBackground/MarginContainer/VBoxContainer/RequiredLabel
@onready var title_line: LineEdit = $GlobalBackground/MarginContainer/VBoxContainer/Title/TitleLine
@onready var author_line: LineEdit = $GlobalBackground/MarginContainer/VBoxContainer/Author/AuthorLine
@onready var description_box: TextEdit = $GlobalBackground/MarginContainer/VBoxContainer/Description/MarginContainer/DescriptionBox
@onready var button_spacer: Control = $GlobalBackground/MarginContainer/VBoxContainer/ButtonSpacer

var _story_id: int
var _title: String
var _author: String
var _desc: String


func _ready() -> void:
	top_label.add_theme_font_size_override("font_size", 32)
	required_label.add_theme_font_size_override("font_size", 10)
	required_label.add_theme_color_override("font_color", Color.DARK_RED) # set to ab000d later
	SignalManager.story_edit_popup.connect(get_info_to_edit)


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
		# Take info in bars and time snippet and send it to database
		var title: String = title_line.text
		var author: String = author_line.text
		var desc: String = description_box.text
		var update_date: String = StoryManager.get_date()
		
		# Write update query
		var query: String = """
			UPDATE Stories 
			SET title = ?,
				author = ?,
				description = ?,
				updatedAt = ?
			WHERE storyId = ?;
		"""
		var params: Array = [title, author, desc, update_date, _story_id]
		
		# Update database
		DatabaseManager.db.query_with_bindings(query, params)
		
		# Emit signal that popup should close
		SignalManager.story_edit_popup.emit(false)
		
		# Set all boxes and top label back to default
		reset_text_boxes()


func _on_cancel_button_pressed() -> void:
	SignalManager.story_edit_popup.emit(false)
	reset_text_boxes()


func get_info_to_edit(f: bool) -> void:
	if f == true:
		var info: Dictionary = StoryManager.get_story_info()
		
		_story_id = info["story_id"]
		_title = info["title"]
		_author = info["author"]
		_desc = info["description"]
		
		title_line.text = _title
		author_line.text = _author
		description_box.text = _desc
