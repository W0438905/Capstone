extends CanvasLayer

@onready var title_line: LineEdit = $MarginContainer/VBoxContainer/TopBar/TitleLine
@onready var content_edit: TextEdit = $MarginContainer/VBoxContainer/MarginContainer/ContentEdit
@onready var autosave_timer: Timer = $AutosaveTimer

var info: Dictionary
var id: int
var table: String
var pk: String
var story_id: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	chapter_or_note()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func chapter_or_note() -> void:
	var cn: String = StoryManager.get_flip_flop()
	if cn == "chapter":
		info = StoryManager.get_chapter_info()
		id = info["chapter_id"]
		table = "CHAPTERS"
		pk = "chapterId"
		#print("chapter info in content:")
		#print(id)
		
	elif cn == "note":
		info = StoryManager.get_note_info()
		id = info["note_id"]
		table = "NOTES"
		pk = "noteId"
		#print("note info in content:")
		#print(id)
		
	else:
		pass # write an error to the content box and disable the save button


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Chapters/chapters.tscn")


func _on_save_button_pressed() -> void:
	story_id = info["story_id"]
	title_line.text = info["title"]
	content_edit.text = info["content"]
	
	var title: String = title_line.text
	var content: String = content_edit.text
	var date: String = StoryManager.get_date()
	
	# Write content changes to respective table
	var content_query: String = """
		UPDATE %s
		SET title = ?, content = ?, updatedAt = ?
		WHERE %s = ?
	""" % [table, pk]
	var content_params: Array = [title, content, date, id]
	
	# Update when the story was updated
	var story_query: String = """
		UPDATE Stories
		SET updatedAt = ?
		WHERE storyId = ?
	"""
	var story_params: Array = [date, story_id]
	
	DatabaseManager.db.query_with_bindings(content_query, content_params)
	DatabaseManager.db.query_with_bindings(story_query, story_params)


func _on_timer_timeout() -> void:
	_on_save_button_pressed()
