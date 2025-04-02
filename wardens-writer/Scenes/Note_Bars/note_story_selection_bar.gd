extends HBoxContainer

class_name NoteStoryBar

@onready var drag_label: Label = $HBoxContainer/DragLabel
@onready var bar_button: Button = $HBoxContainer/BarButton

const FONT_SIZE: int = 32

var story_info: Dictionary


func _ready() -> void:
	drag_label.add_theme_font_size_override("font_size", FONT_SIZE)
	bar_button.add_theme_font_size_override("font_size", FONT_SIZE)


func _process(delta: float) -> void:
	pass


# Called from notes.gd
func set_story_info(info: Dictionary) -> void:
	# Set data to script-wide
	story_info = info
	#print(_story_info)
	# Update bar with queried info
	bar_button.text = " " + story_info["title"]
	#button.text = info["created_at"]


# Main story bar button
func _on_bar_button_pressed() -> void:
	StoryManager.set_story_info(story_info)
	get_tree().change_scene_to_file("res://Scenes/Note_Select/note_select.tscn")
