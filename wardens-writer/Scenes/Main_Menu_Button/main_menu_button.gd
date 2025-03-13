extends TextureButton

# Temporary resizing 
const HOVER_SCALE: Vector2 = Vector2(1.1, 1.1)
const DEFAULT_SCALE: Vector2 = Vector2(1.0, 1.0)

@export var button_name: String = ""

@onready var name_label: Label = $MarginContainer/NameLabel


func _ready() -> void:
	name_label.text = button_name.capitalize()
	pivot_offset = Vector2(size.x / 2, size.y / 2)
	# All other styling is done via themes
	match button_name:
		"write":
			name_label.add_theme_font_size_override("font_size", 52)
		"notes":
			name_label.add_theme_font_size_override("font_size", 36)
		"help":
			name_label.add_theme_font_size_override("font_size", 34)
		"options":
			name_label.add_theme_font_size_override("font_size", 28)
		"exit":
			name_label.add_theme_font_size_override("font_size", 30)
		"main_menu":
			name_label.add_theme_font_size_override("font_size", 24)
		_:
			name_label.add_theme_font_size_override("font_size", 24)
	
	#name_label.add_theme_font_size_override("font_size", int(self.size.x / 5))


func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	if button_name == "exit":
		get_tree().quit() # Exits the program
	elif button_name == "main_menu":
		# .capitalize() turns main_menu into Main Menu, which is not Main_Menu like I need it to be.
		# This is the fix
		var button_route: PackedScene = load("res://Scenes/Main_Menu/main_menu.tscn")
		get_tree().change_scene_to_packed(button_route)
	else:
		var button_route: PackedScene = load("res://Scenes/" + button_name.capitalize() + "/" + button_name + ".tscn")
		get_tree().change_scene_to_packed(button_route)
		#print("Button Clicked: " + button_name) # Debug
		#print("res://Scenes/" + button_name.capitalize() + "/" + button_name + ".tscn") # Debug


func _on_mouse_entered() -> void:
	# Make sure the pivot offset is in the center of the button
	scale = HOVER_SCALE


func _on_mouse_exited() -> void:
	scale = DEFAULT_SCALE
