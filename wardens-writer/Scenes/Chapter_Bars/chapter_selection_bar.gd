extends HBoxContainer

class_name ChapterBar

@onready var drag_label: Label = $HBoxContainer/DragLabel
@onready var button: Button = $HBoxContainer/Button
@onready var menu_button: MenuButton = $HBoxContainer2/MenuButton

const FONT_SIZE: int = 32

var _chapter_info: Dictionary


func _ready() -> void:
	drag_label.add_theme_font_size_override("font_size", FONT_SIZE)
	button.add_theme_font_size_override("font_size", FONT_SIZE)
	
	# Retrieves the ids from the MenuButton items and sends it to _on_menu_item_selected func
	menu_button.get_popup().id_pressed.connect(_on_menu_item_selected)


func _process(delta: float) -> void:
	pass


# Called from chapters.gd
func set_chapter_info(info: Dictionary) -> void:
	# Set data to script-wide
	_chapter_info = info
	#print(_chapter_info)
	# Update bar with queried info
	button.text = " " + _chapter_info["title"]
	#button.text = _chapter_info["created_at"]


func _on_menu_item_selected(id: int) -> void:
	match id:
		0:
			print("Info")
		1:
			print("Edit")
			#SignalManager.send_story_info.emit(_story_info)
			#SignalManager.story_edit_popup.emit(true)
		2:
			print("Delete")


func _on_button_pressed() -> void:
	pass
	#SignalManager.send_story_info.emit(_story_info)
	#get_tree().change_scene_to_file("res://Scenes/Chapters/chapters.tscn")
