extends Control

@onready var top_label: Label = $ColorRect/MarginContainer/VBoxContainer/TopLabel
@onready var required_label: Label = $ColorRect/MarginContainer/VBoxContainer/RequiredLabel
@onready var title_line: LineEdit = $ColorRect/MarginContainer/VBoxContainer/Title/TitleLine
@onready var description_box: TextEdit = $ColorRect/MarginContainer/VBoxContainer/Description/MarginContainer/DescriptionBox


func _ready() -> void:
	top_label.add_theme_font_size_override("font_size", 32)
	required_label.add_theme_font_size_override("font_size", 10)
	required_label.add_theme_color_override("font_color", Color.DARK_RED) # set to ab000d later


func _process(delta: float) -> void:
	pass
	

func reset_text_boxes() -> void:
	title_line.text = ""
	description_box.text = ""
	required_label.add_theme_font_size_override("font_size", 10)
	required_label.text = "*Required"

func _on_confirm_button_pressed() -> void:
	if title_line.text.is_empty():
		required_label.add_theme_font_size_override("font_size", 16)
		required_label.text = "*Chapter Must Have Title"
	else:
		# if not, take info in bars and time snippet and send it to database
		var title: String = title_line.text
		var desc: String = description_box.text
		var create_date: String = StoryManager.get_date()
		var update_date: String = StoryManager.get_date()
		
		# Get the selected story info
		var story_info: Dictionary = StoryManager.get_story_info()
		
		# Get the largest chapterOrder number under the current storyId fk
		var order_query: String = "SELECT COALESCE(MAX(chapterOrder), 0) AS chapter_order FROM Chapters WHERE storyId = %d" % [story_info["story_id"]]
		DatabaseManager.db.query(order_query)
		
		# Write the result to var, retrieve the int and add one for the new chapterOrder num
		var chapter_order_arr: Array[Dictionary] = DatabaseManager.db.query_result
		var chapter_order: int = (chapter_order_arr[0]["chapter_order"] + 1)
		
		# Write query
		var query: String = """
			INSERT INTO Chapters 
			(storyId, title, description, content, chapterOrder, createdAt, updatedAt) 
			VALUES (?, ?, ?, ?, ?, ?, ?)
		"""
		var params: Array = [story_info["story_id"], title, desc, "", chapter_order, create_date, update_date]
		
		# Send to database
		DatabaseManager.db.query_with_bindings(query, params)
		
		# Emit signal that popup should close
		SignalManager.chapter_create_popup.emit(false)
		
		# Set all boxes and top label back to default
		reset_text_boxes()


func _on_cancel_button_pressed() -> void:
	SignalManager.chapter_create_popup.emit(false)
	reset_text_boxes()
