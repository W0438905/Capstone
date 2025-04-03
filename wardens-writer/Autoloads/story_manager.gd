extends Node

var story_info: Dictionary
var chapter_info: Dictionary
var note_info: Dictionary
var flip_flop: String # Controls the queries made in the content page
var del_info: Array


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
	# Get the system's date
	var dt = Time.get_datetime_dict_from_system()
	
	# Format it as a string and send it off
	return "%04d %02d %02d %02d %02d %02d" % [
		dt["year"], dt["month"], dt["day"], dt["hour"], dt["minute"], dt["second"]
	]


func display_date(date: String) -> String:
	# Break date string into array at each space
	var d: Array = date.split(" ")
	
	# Grab each part of the array and write to vars
	var year: String = d[0]
	var month: String = d[1]
	var day: String = d[2]
	var hour: int = int(d[3]) # Need string as int for hour math
	var minute: String = d[4]
	# Though they are necessary for db sorting, I've chosen to not display seconds
	
	# Make array of month names
	var month_names: Array = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", 
					"Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
	# Get the index of the month array using the month number - 1
	var month_name: String = month_names[int(month) - 1]
	
	# If the hour is less than 12, it is AM. Otherwise the time is PM
	var am_pm: String = "AM" if hour < 12 else "PM"
	
	# Get the remainder of hour / 12 (ex: 17 % 12 = 5)
	var twelve_hour: int = hour % 12
	# If hour was 12, then remainder would be 0. This catches that
	if twelve_hour == 0:
		twelve_hour = 12
	
	# Put the string together and return it do be displayed
	return "%s %s, %s at %d:%s %s" % [
		month_name,
		day,						# Day
		year,						# Year
		twelve_hour,				# Hour
		minute,						# Minute
		am_pm						# AM or PM
	]


func set_flip_flop(cn: String) -> void:
	# Sets whether the Content page should handle chapters or notes
	flip_flop = cn


func get_flip_flop() -> String:
	return flip_flop


func set_prep_delete(info: Array) -> void:
	del_info = info


func get_prep_delete() -> Array:
	return del_info
