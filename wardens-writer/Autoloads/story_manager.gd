extends Node

var story_info: Dictionary
var chapter_info: Dictionary
var note_info: Dictionary
var flip_flop: String # Controls the queries made in the content page


func _ready() -> void:
	pass


func set_story_info(info: Dictionary) -> void:
	# Gets story_id, title, author, description, created_at, and updated_at
	story_info = info
	#print("setting story:")
	#print(story_info)


func get_story_info() -> Dictionary:
	#print("getting story:")
	#print(story_info)
	return story_info


func set_chapter_info(info: Dictionary) -> void:
	# Gets chapter_id, story_id, title, description, content, chapter_order, created_at, and updated_at
	chapter_info = info
	#print("setting chapter:")
	#print(chapter_info)


func get_chapter_info() -> Dictionary:
	#print("getting chapter:")
	#print(chapter_info)
	return chapter_info


func set_note_info(info: Dictionary) -> void:
	# Gets note_id, story_id, chapter_id, note_type, title, content, created_at, and updated_at
	note_info = info
	#print("setting note:")
	#print(chapter_info)


func get_note_info() -> Dictionary:
	#print("getting note:")
	#print(note_info)
	return note_info


func get_date() -> String:
	var month_arr: Array = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
	var dt = Time.get_datetime_dict_from_system()
	
	var month: String = month_arr[dt["month"]-1]
	var day: int = dt["day"]
	var year: int = dt["year"]
	var hour: int = dt["hour"]
	var min: int = dt["minute"]
	var sec: int = dt["second"]
	
	var date_string = "%s-%02d-%04d %02d:%02d:%02d" % [month, day, year, hour, min, sec]
	return date_string


func set_flip_flop(cn: String) -> void:
	flip_flop = cn


func get_flip_flop() -> String:
	return flip_flop
