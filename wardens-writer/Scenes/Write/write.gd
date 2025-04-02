extends CanvasLayer

@onready var s_create_popup: Control = $StoryCreatePopup
@onready var s_edit_popup: Control = $StoryEditPopup
@onready var v_box_story: VBoxContainer = $MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/VBoxStory
@onready var page_label: Label = $MarginContainer/VBoxContainer/Heading/PageLabel
@onready var back_button: Button = $MarginContainer/VBoxContainer/Heading/BackButton

const STORY_SELECTION_BAR = preload("res://Scenes/Story_Bars/story_selection_bar.tscn")

var popup_flag: bool = false


func _ready() -> void:
	page_label.add_theme_font_size_override("font_size", 48)
	back_button.add_theme_font_size_override("font_size", 48)
	SignalManager.story_create_popup.connect(story_create_popup)
	SignalManager.story_edit_popup.connect(story_edit_popup)
	add_story_bars()


func _process(_delta: float) -> void:
	pass
	# not needed for signals, might not be needed at all


func story_create_popup(f: bool) -> void:
	popup_flag = f
	if popup_flag:
		s_create_popup.visible = true
	else:
		s_create_popup.visible = false
		add_story_bars()


func story_edit_popup(f: bool) -> void:
	popup_flag = f
	if popup_flag:
		s_edit_popup.visible = true
	else:
		s_edit_popup.visible = false
		add_story_bars()


func add_story_bars() -> void:
	# Remove all bars in VBox to prepare for updating
	for s in v_box_story.get_children():
		s.queue_free()
	
	# Query database to get all stories
	DatabaseManager.db.query("SELECT * FROM Stories ORDER BY updatedAt DESC;")
	var stories: Array[Dictionary] = DatabaseManager.db.query_result
	
	#print(stories)
	
	# Iterate through array
	for story in stories:
		# Make new bar
		var new_bar: StoryBar = STORY_SELECTION_BAR.instantiate()
		v_box_story.add_child(new_bar)
		
		# Send story info to story_selection_bar
		new_bar.set_story_info({
			"story_id": story["storyId"],
			"title": story["title"],
			"author": story["author"],
			"description": story["description"],
			"created_at": story["createdAt"],
			"updated_at": story["updatedAt"]
		})


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Main_Menu/main_menu.tscn")
