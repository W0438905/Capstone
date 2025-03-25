extends Node

@onready var top_label: Label = $ColorRect/MarginContainer/VBoxContainer/TopLabel
@onready var required_label: Label = $ColorRect/MarginContainer/VBoxContainer/RequiredLabel
@onready var title_line: LineEdit = $ColorRect/MarginContainer/VBoxContainer/Title/TitleLine
@onready var author_line: LineEdit = $ColorRect/MarginContainer/VBoxContainer/Author/AuthorLine
@onready var description_box: TextEdit = $ColorRect/MarginContainer/VBoxContainer/Description/MarginContainer/DescriptionBox


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


func _on_confirm_button_pressed() -> void:
	if title_line.text.is_empty():
		required_label.add_theme_font_size_override("font_size", 16)
		required_label.text = "*Story Must Have Title"
	else:
		# if not, take info in bars and time snippet and send it to database
		var title: String = title_line.text
		var author: String = author_line.text
		var desc: String = description_box.text
		var create_date: String = get_date()
		var update_date: String = get_date()
		
		# Write query
		var query: String = "INSERT INTO Stories (title, author, description, createdAt, updatedAt) 
		VALUES ('%s', '%s', '%s', '%s', '%s');" % [title, author, desc, create_date, update_date]
		
		# Send to database
		DatabaseManager.db.query(query)
		
		# Emit signal that popup should close
		SignalManager.story_create_popup.emit(false)
		# Set all boxes and top label back to default
		reset_text_boxes()


func _on_cancel_button_pressed() -> void:
	SignalManager.story_create_popup.emit(false)
	reset_text_boxes()


func get_date() -> String:
	var month_arr: Array = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
	var dt = Time.get_datetime_dict_from_system()
	
	var month: String = month_arr[dt["month"]-1]
	var day: int = dt["day"]
	var year: int = dt["year"]
	var hour: int = dt["hour"]
	var min: int = dt["minute"]
	var sec: int = dt["second"]
	
	var date_string = "%s-%02d-%04d %02d:%02d:%02d" % [month, day, year, hour, min, sec]
	return date_string
