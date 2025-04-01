extends HBoxContainer

class_name ChapterBar

@onready var drag_label: Label = $HBoxContainer/DragLabel
@onready var bar_button: Button = $HBoxContainer/BarButton
@onready var menu_button: MenuButton = $HBoxContainer2/MenuButton

const FONT_SIZE: int = 32

var chapter_info: Dictionary


func _ready() -> void:
	drag_label.add_theme_font_size_override("font_size", FONT_SIZE)
	bar_button.add_theme_font_size_override("font_size", FONT_SIZE)
	
	# Retrieves the ids from the MenuButton items and sends it to _on_menu_item_selected func
	menu_button.get_popup().id_pressed.connect(_on_menu_item_selected)


func _process(delta: float) -> void:
	pass


# Called from chapters.gd
func set_chapter_info(info: Dictionary) -> void:
	# Set data to script-wide
	chapter_info = info
	#print(chapter_info)
	# Update bar with queried info
	bar_button.text = " " + chapter_info["title"]
	#button.text = chapter_info["created_at"]


func _on_menu_item_selected(id: int) -> void:
	match id:
		0:
			print("Info")
		1:
			print("Edit")
			#StoryManager.set_chapter_info(chapter_info)
			#SignalManager.story_edit_popup.emit(true)
		2:
			print("Delete")


func _on_bar_button_pressed() -> void:
	# change signal to sent_chapter_info
	StoryManager.set_chapter_info(chapter_info)
	StoryManager.set_flip_flop("chapter") # Sets content page to take chapters
	get_tree().change_scene_to_file("res://Scenes/Content/content.tscn")
