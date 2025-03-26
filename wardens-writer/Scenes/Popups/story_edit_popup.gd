extends Node

@onready var top_label: Label = $ColorRect/MarginContainer/VBoxContainer/TopLabel
@onready var required_label: Label = $ColorRect/MarginContainer/VBoxContainer/RequiredLabel
@onready var title_line: LineEdit = $ColorRect/MarginContainer/VBoxContainer/Title/TitleLine
@onready var author_line: LineEdit = $ColorRect/MarginContainer/VBoxContainer/Author/AuthorLine
@onready var description_box: TextEdit = $ColorRect/MarginContainer/VBoxContainer/Description/MarginContainer/DescriptionBox

var _story_id: int
var _title: String
var _author: String
var _desc: String

# SET TEXT BOXES TO EXISTING QUERIED DATA

func _ready() -> void:
	top_label.add_theme_font_size_override("font_size", 32)
	required_label.add_theme_font_size_override("font_size", 10)
	required_label.add_theme_color_override("font_color", Color.DARK_RED) # set to ab000d later
	SignalManager.send_story_info.connect(set_story_info)


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
		# Take info in bars and time snippet and send it to database
		var title: String = title_line.text
		var author: String = author_line.text
		var desc: String = description_box.text
		var update_date: String = get_date()
		
		# Write update query
		var query: String = """
			UPDATE Stories 
			SET title = '%s',
				author = '%s',
				description = '%s',
				updatedAt = '%s'
			WHERE storyId = %d
		""" % [title, author, desc, update_date, _story_id]
		
		# Update database
		DatabaseManager.db.query(query)
		
		# Emit signal that popup should close
		SignalManager.story_edit_popup.emit(false)
		# Set all boxes and top label back to default
		reset_text_boxes()


func _on_cancel_button_pressed() -> void:
	SignalManager.story_edit_popup.emit(false)
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


func set_story_info(info: Dictionary) -> void:
	_story_id = info["story_id"]
	_title = info["title"]
	_author = info["author"]
	_desc = info["description"]
	
	title_line.text = _title
	author_line.text = _author
	description_box.text = _desc
