extends HBoxContainer

class_name StoryBar

@onready var drag_label: Label = $HBoxContainer/DragLabel
@onready var button: Button = $HBoxContainer/Button
@onready var menu_button: MenuButton = $HBoxContainer2/MenuButton

const FONT_SIZE: int = 32

var _story_info: Dictionary


func _ready() -> void:
	drag_label.add_theme_font_size_override("font_size", FONT_SIZE)
	button.add_theme_font_size_override("font_size", FONT_SIZE)
	
	# Retrieves the ids from the MenuButton items and sends it to _on_menu_item_selected func
	menu_button.get_popup().id_pressed.connect(_on_menu_item_selected)


func _process(delta: float) -> void:
	pass


func set_story_info(info: Dictionary) -> void:
	# Set data to script-wide
	_story_info = info
	#print(_story_info)
	# Update bar with queried info
	button.text = " " + info["title"]
	#button.text = info["created_at"]


func _on_menu_item_selected(id: int) -> void:
	match id:
			0:
				print("Info")
			1:
				SignalManager.story_edit_popup.emit(true)
				SignalManager.send_story_info.emit(_story_info)
			2:
				print("Delete")
			3:
				print("Export As")
