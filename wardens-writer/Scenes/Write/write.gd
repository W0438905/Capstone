extends CanvasLayer

@onready var story_popup: Control = $StoryCreatePopup
@onready var v_box_story: VBoxContainer = $MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/VBoxStory

const STORY_SELECTION_BAR = preload("res://Scenes/Story_Bars/story_selection_bar.tscn")

var _popup_flag: bool = false


func _ready() -> void:
	SignalManager.story_create_popup.connect(story_create_popup)
	add_story_bars()


func _process(delta: float) -> void:
	pass
	# not needed for signals, might not be needed at all


func story_create_popup(f: bool) -> void:
	_popup_flag = f
	if _popup_flag:
		story_popup.visible = true
	else:
		story_popup.visible = false
		add_story_bars()


func add_story_bars() -> void:
	# Remove all bars in VBox to prepare for updating
	for c in v_box_story.get_children():
		c.queue_free()
	
	# Query database to get all stories
	DatabaseManager.db.query("SELECT title FROM Stories ORDER BY updatedAt")
	var stories: Array[Dictionary] = DatabaseManager.db.query_result
	
	print(stories)
	
	# Iterate through array
	for story in stories:
		# Make new bar
		var new_bar: StoryBar = STORY_SELECTION_BAR.instantiate()
		v_box_story.add_child(new_bar)
		
		# Send story info to story_selection_bar
		new_bar.set_story_info({
			"title": story["title"]#,
			#"author": story["author"],
			#"description": story["description"],
			#"created_at": story["createdAt"],
			#"updated_at": story["updatedAt"]
		})
