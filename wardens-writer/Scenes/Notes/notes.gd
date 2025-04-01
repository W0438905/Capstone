extends CanvasLayer

@onready var v_box_story: VBoxContainer = $MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/VBoxStory

const NOTE_STORY_SELECTION_BAR = preload("res://Scenes/Note_Bars/note_story_selection_bar.tscn")

var popup_flag: bool = false


func _ready() -> void:
	add_story_bars()


func _process(delta: float) -> void:
	pass
	# not needed for signals, might not be needed at all


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
		var new_bar: NoteStoryBar = NOTE_STORY_SELECTION_BAR.instantiate()
		v_box_story.add_child(new_bar)
		
		# Send story info to note_story_selection_bar
		new_bar.set_story_info({
			"story_id": story["storyId"],
			"title": story["title"],
			"author": story["author"],
			"description": story["description"],
			"created_at": story["createdAt"],
			"updated_at": story["updatedAt"]
		})
