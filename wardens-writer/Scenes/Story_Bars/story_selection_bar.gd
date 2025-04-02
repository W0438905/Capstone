extends HBoxContainer

class_name StoryBar

@onready var drag_label: Label = $HBoxContainer/DragLabel
@onready var bar_button: Button = $HBoxContainer/BarButton
@onready var menu_button: MenuButton = $HBoxContainer2/MenuButton

const FONT_SIZE: int = 32

var story_info: Dictionary


func _ready() -> void:
	drag_label.add_theme_font_size_override("font_size", FONT_SIZE)
	bar_button.add_theme_font_size_override("font_size", FONT_SIZE)
	
	# Retrieves the ids from the MenuButton items and sends it to _on_menu_item_selected func
	menu_button.get_popup().id_pressed.connect(_on_menu_item_selected)


func _process(_delta: float) -> void:
	pass


# Called from write.gd
func set_story_info(info: Dictionary) -> void:
	# Set data to script-wide
	story_info = info
	#print(_story_info)
	# Update bar with queried info
	bar_button.text = " " + story_info["title"]
	#button.text = info["created_at"]


func _on_menu_item_selected(id: int) -> void:
	match id:
		0:
			print("Info")
		1:
			StoryManager.set_story_info(story_info)
			SignalManager.story_edit_popup.emit(true)
		2:
			print("Delete")
		3:
			print("Export As")


# Main story bar button
func _on_bar_button_pressed() -> void:
	StoryManager.set_story_info(story_info)
	get_tree().change_scene_to_file("res://Scenes/Chapters/chapters.tscn")
