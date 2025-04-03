extends Control

@onready var caption_label: Label = $GlobalBackground/MarginContainer/VBoxContainer/CaptionLabel
@onready var title_label: Label = $GlobalBackground/MarginContainer/VBoxContainer/TitleLabel
@onready var confirm_button: Button = $GlobalBackground/MarginContainer/VBoxContainer/Buttons/ConfirmButton
@onready var cancel_button: Button = $GlobalBackground/MarginContainer/VBoxContainer/Buttons/CancelButton

var del_info: Array
var table: String
var id_name: String
var id: int
var title: String

func _ready() -> void:
	caption_label.add_theme_font_size_override("font_size", 24)
	title_label.add_theme_font_size_override("font_size", 28)
	confirm_button.add_theme_font_size_override("font_size", 20)
	cancel_button.add_theme_font_size_override("font_size", 20)
	SignalManager.delete_popup.connect(get_info_to_del)


func get_info_to_del(f: bool) -> void:
	if f == true:
		# [0] = Table name, [1] = id name, [2] = id, [3] = title
		del_info = StoryManager.get_prep_delete()
		
		table = del_info[0]
		id_name = del_info[1]
		id = del_info[2]
		title = del_info[3]
		
		title_label.text = title


func _on_confirm_button_pressed() -> void:
	var del_query: String = """
		DELETE FROM %s
		WHERE %s = %d;
	""" % [table, id_name, id]
	
	# Can't use placeholders with table or field names in SQLite
	DatabaseManager.db.query(del_query)
	SignalManager.delete_popup.emit(false)


func _on_cancel_button_pressed() -> void:
	SignalManager.delete_popup.emit(false)
