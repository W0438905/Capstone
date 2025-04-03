extends CanvasLayer

@onready var v_box_note: VBoxContainer = $MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/VBoxNote
@onready var n_create_popup: Control = $NoteCreatePopup
@onready var back_button: Button = $MarginContainer/VBoxContainer/Heading/BackButton
@onready var page_label: Label = $MarginContainer/VBoxContainer/Heading/PageLabel
@onready var del_popup: Control = $DeletePopup


@onready var wip_popup: Control = $WIPPopup

const NOTE_SELECTION_BAR = preload("res://Scenes/Note_Bars/note_selection_bar.tscn")

var popup_flag: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	page_label.add_theme_font_size_override("font_size", 48)
	back_button.add_theme_font_size_override("font_size", 48)
	SignalManager.note_create_popup.connect(note_create_popup)
	SignalManager.delete_popup.connect(delete_popup)
	
	SignalManager.wip_popup.connect(wip)
	
	add_note_bars()
	#print("note:")
	#print(StoryManager.get_note_info())


func wip(f: bool) -> void:
	popup_flag = f
	if popup_flag:
		wip_popup.visible = true
	else:
		wip_popup.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func note_create_popup(f: bool) -> void:
	popup_flag = f
	if popup_flag:
		n_create_popup.visible = true
	else:
		n_create_popup.visible = false
		add_note_bars()


func delete_popup(f: bool) -> void:
	popup_flag = f
	if popup_flag:
		del_popup.visible = true
	else:
		del_popup.visible = false
		add_note_bars()


func add_note_bars() -> void:
	# Remove all bars in VBox to prepare for updating
	for n in v_box_note.get_children():
		n.queue_free()
	
	var story_info: Dictionary = StoryManager.get_story_info()
	var story_id: int = story_info["story_id"]
	
	#print(story_id)
	
	# Query database to get all notes
	var query: String = """
		SELECT * FROM Notes 
		WHERE storyId = %d 
		ORDER BY updatedAt DESC;
	""" % [story_id]
	DatabaseManager.db.query(query) 
	var notes: Array[Dictionary] = DatabaseManager.db.query_result
	
	#print("notes:")
	#print(notes)
	
	# Iterate through array
	for note in notes:
		# Make new bar
		var new_bar: NoteBar = NOTE_SELECTION_BAR.instantiate()
		v_box_note.add_child(new_bar)
		
		#print(note)
		
		# Send note info to note_selection_bar
		new_bar.set_note_info({
			"note_id": note["noteId"],
			"story_id": note["storyId"],
			"chapter_id": note["chapterId"],
			"note_type": note["noteType"],
			"title": note["title"],
			"content": note["content"],
			"created_at": note["createdAt"],
			"updated_at": note["updatedAt"]
		})


func _on_to_chapters_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Chapters/chapters.tscn")


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Notes/notes.tscn")
