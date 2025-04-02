extends CanvasLayer

@onready var back_button: Button = $MarginContainer/VBoxContainer/TopBar/BackButton
@onready var save_button: Button = $MarginContainer/VBoxContainer/TopBar/SaveButton
@onready var required_label: Label = $MarginContainer/VBoxContainer/TopBar/RequiredLabel
@onready var title_line: LineEdit = $MarginContainer/VBoxContainer/TopBar/TitleLine
@onready var note_list_button: Button = $MarginContainer/VBoxContainer/TopBar/NoteListButton
@onready var content_edit: TextEdit = $MarginContainer/VBoxContainer/MarginContainer/ContentEdit
@onready var autosave_timer: Timer = $AutosaveTimer

var cn: String
var info: Dictionary
var id: int
var table: String
var pk: String
var story_id: int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	note_list_button.add_theme_font_size_override("font_size", 32)
	back_button.add_theme_font_size_override("font_size", 24)
	save_button.add_theme_font_size_override("font_size", 20)
	required_label.add_theme_font_size_override("font_size", 16)
	required_label.add_theme_color_override("font_color", Color.DARK_RED) # set to ab000d later
	chapter_or_note()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func chapter_or_note() -> void:
	cn = StoryManager.get_flip_flop()
	if cn == "chapter":
		info = StoryManager.get_chapter_info()
		id = info["chapter_id"]
		table = "CHAPTERS"
		pk = "chapterId"
		
		# Do not move these, they add the chapter info to the page
		title_line.text = info["title"]
		content_edit.text = info["content"]
		
		#print("chapter info in content:")
		#print(id)
		
	elif cn == "note":
		info = StoryManager.get_note_info()
		id = info["note_id"]
		table = "NOTES"
		pk = "noteId"
		
		# Do not move these, they add the note info to the page
		title_line.text = info["title"]
		content_edit.text = info["content"]
		
		#print("note info in content:")
		#print(id)
		
	else:
		pass # write an error to the content box and disable the save button


func _on_back_button_pressed() -> void:
	if cn == "chapter":
		get_tree().change_scene_to_file("res://Scenes/Chapters/chapters.tscn")
	elif cn == "note":
		get_tree().change_scene_to_file("res://Scenes/Note_Select/note_select.tscn")
	else:
		get_tree().change_scene_to_file("res://Scenes/Main_Menu/main_menu.tscn")


func _on_save_button_pressed() -> void:
	if title_line.text.is_empty():
		required_label.visible = true
		return
	required_label.visible = false
	
	story_id = info["story_id"]
	
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
