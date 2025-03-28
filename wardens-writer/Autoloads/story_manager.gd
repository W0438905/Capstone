extends Node

var _story_info: Dictionary


func _ready() -> void:
	SignalManager.send_story_info.connect(set_story_info)


func set_story_info(info: Dictionary) -> void:
	# Gets story_id, title, author, description, created_at, and updated_at
	_story_info = info
	#print("setting")
	#print(_story_info)

func get_story_info() -> Dictionary:
	#print("getting")
	#print(_story_info)
	return _story_info


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
