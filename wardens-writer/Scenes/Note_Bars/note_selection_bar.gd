extends HBoxContainer

class_name NoteBar

@onready var drag_label: Label = $HBoxContainer/DragLabel
@onready var bar_button: Button = $HBoxContainer/BarButton
@onready var menu_button: MenuButton = $HBoxContainer2/MenuButton

const FONT_SIZE: int = 32

var note_info: Dictionary


func _ready() -> void:
	drag_label.add_theme_font_size_override("font_size", FONT_SIZE)
	bar_button.add_theme_font_size_override("font_size", FONT_SIZE)
	
	# Retrieves the ids from the MenuButton items and sends it to _on_menu_item_selected func
	menu_button.get_popup().id_pressed.connect(_on_menu_item_selected)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


# Called from note_select.gd
func set_note_info(info: Dictionary) -> void:
	# Set data to script-wide
	note_info = info
	#print(note_info)
	# Update bar with queried info
	bar_button.text = " " + note_info["title"]
	#button.text = note_info["created_at"]


func _on_menu_item_selected(id: int) -> void:
	match id:
		0:
			print("Info")
		1:
			print("Edit")
			#StoryManager.set_note_info(chapter_info)
			#SignalManager.note_edit_popup.emit(true)
		2:
			print("Delete")


func _on_bar_button_pressed() -> void:
	StoryManager.set_note_info(note_info)
	StoryManager.set_flip_flop("note") # Sets content page to take notes
	get_tree().change_scene_to_file("res://Scenes/Content/content.tscn")
