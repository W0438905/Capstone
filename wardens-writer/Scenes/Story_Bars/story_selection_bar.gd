extends HBoxContainer

class_name StoryBar

@onready var drag_label: Label = $HBoxContainer/DragLabel
@onready var button: Button = $HBoxContainer/Button
@onready var menu_button: MenuButton = $HBoxContainer2/MenuButton

const FONT_SIZE: int = 32

#query db via function, return result, write result to var
#write story title to button.text
#instantiate bar to write.tscn (see main.gd in foxy-antics or game.gd in gemcatcher)

func _ready() -> void:
	drag_label.add_theme_font_size_override("font_size", FONT_SIZE)
	button.add_theme_font_size_override("font_size", FONT_SIZE)
	#button.text = "beans"
	
	# Retrieves the ids from the MenuButton items and sends it to _on_menu_item_selected func
	menu_button.get_popup().id_pressed.connect(_on_menu_item_selected)


func _process(delta: float) -> void:
	pass


# Make get_story_info() to hold all story info?
# set_story_info would pull from get
# how does the popup get the info? 


func set_story_info(info: Dictionary) -> void:
	# Update bar with queried info
	button.text = " " + info["title"]
	#button.text = info["created_at"]


func _on_menu_item_selected(id: int) -> void:
	match id:
			0:
				print("Info")
				# open popup
				# query db based on title of button
				
				# make info popup and go from there
			1:
				print("Edit")
			2:
				print("Delete")
			3:
				print("Export As")
