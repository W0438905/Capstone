extends CanvasLayer

@onready var v_box_chapter: VBoxContainer = $MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/VBoxChapter
@onready var c_create_popup: Control = $ChapterCreatePopup

const CHAPTER_SELECTION_BAR = preload("res://Scenes/Chapter_Bars/chapter_selection_bar.tscn")

var _popup_flag: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.chapter_create_popup.connect(chapter_create_popup)
	add_chapter_bars()
	#print("chapter:")
	#print(StoryManager.get_story_info())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func chapter_create_popup(f: bool) -> void:
	_popup_flag = f
	if _popup_flag:
		c_create_popup.visible = true
	else:
		c_create_popup.visible = false
		add_chapter_bars()


func add_chapter_bars() -> void:
	# Remove all bars in VBox to prepare for updating
	for c in v_box_chapter.get_children():
		c.queue_free()
	
	var story_info: Dictionary = StoryManager.get_story_info()
	var story_id: int = story_info["story_id"]
	
	#print(story_id)
	
	# Query database to get all chapters
	var query: String = """
		SELECT * FROM Chapters 
		WHERE storyId = %d 
		ORDER BY updatedAt DESC;
	""" % [story_id]
	DatabaseManager.db.query(query) 
	var chapters: Array[Dictionary] = DatabaseManager.db.query_result
	
	#print("chapters:")
	#print(chapters)
	
	# Iterate through array
	for chapter in chapters:
		# Make new bar
		var new_bar: ChapterBar = CHAPTER_SELECTION_BAR.instantiate()
		v_box_chapter.add_child(new_bar)
		
		#print(chapter)
		
		# chapterid
		# storyid
		# title        <input *required
		# description  <input
		# content
		# chapterOrder <done automatically
		# createdat
		# updatedat
		
		# Send chapter info to chapter_selection_bar
		new_bar.set_chapter_info({
			"chapter_id": chapter["chapterId"],
			"story_id": chapter["storyId"],
			"title": chapter["title"],
			"description": chapter["description"],
			"content": chapter["content"],
			"chapter_order": chapter["chapterOrder"],
			"created_at": chapter["createdAt"],
			"updated_at": chapter["updatedAt"]
		})
