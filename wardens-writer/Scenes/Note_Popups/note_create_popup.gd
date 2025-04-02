extends Control

@onready var top_label: Label = $ColorRect/MarginContainer/VBoxContainer/TopLabel
@onready var required_label: Label = $ColorRect/MarginContainer/VBoxContainer/RequiredLabel
@onready var title_line: LineEdit = $ColorRect/MarginContainer/VBoxContainer/Title/TitleLine


func _ready() -> void:
	top_label.add_theme_font_size_override("font_size", 32)
	required_label.add_theme_font_size_override("font_size", 10)
	required_label.add_theme_color_override("font_color", Color.DARK_RED) # set to ab000d later


func _process(delta: float) -> void:
	pass


func reset_text_boxes() -> void:
	title_line.text = ""
	required_label.add_theme_font_size_override("font_size", 10)
	required_label.text = "*Required"


func _on_confirm_button_pressed() -> void:
	if title_line.text.is_empty():
		required_label.add_theme_font_size_override("font_size", 16)
		required_label.text = "*Story Must Have Title"
	else:
		# if not, take info in bars and time snippet and send it to database
		
		var title: String = title_line.text
		var create_date: String = StoryManager.get_date()
		var update_date: String = StoryManager.get_date()
		
		# Get the selected story info
		var story_info: Dictionary = StoryManager.get_story_info()
		
		# Recieve values from note creation bar later
		var chapter_id = null
		var note_type: int = 0
		
		# Write query
		var note_query: String = """
			INSERT INTO Notes 
			(storyId, chapterId, noteType, title, content, createdAt, updatedAt) 
			VALUES (?, ?, ?, ?, ?, ?, ?)
		"""
		var note_params: Array = [story_info["story_id"], chapter_id, note_type, title, "", create_date, update_date]
		
		# storyId
		# chapterId
		# noteType
		# title
		# content
		# createdAt
		# updatedAt
		
		# Send to database
		DatabaseManager.db.query_with_bindings(note_query, note_params)
		
		# Update when the story was updated
		var date_query: String = """
			UPDATE Stories
			SET updatedAt = ?
			WHERE storyId = ?
		"""
		var date_params: Array = [update_date, story_info["story_id"]]
		
		# Update update date of story
		DatabaseManager.db.query_with_bindings(date_query, date_params)
		
		# Emit signal that popup should close
		SignalManager.note_create_popup.emit(false)
		# Set all boxes and top label back to default
		reset_text_boxes()


func _on_cancel_button_pressed() -> void:
	SignalManager.note_create_popup.emit(false)
	reset_text_boxes()
