extends TextureButton

const HOVER_SCALE: Vector2 = Vector2(1.1, 1.1)
const DEFAULT_SCALE: Vector2 = Vector2(1.0, 1.0)

@export var button_route: String = ""

@onready var name_label: Label = $NameLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	name_label.text = button_route
	#_level_scene = load("res://Scenes/Level/level%s.tscn" % level_number)
	
	# make two exported vars, one for the display name and another for the path
	# or format one to fill both


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	pass #get_tree().change_scene_to_packed(_level_scene)


func _on_mouse_entered() -> void:
	# Make sure the pivot offset is in the center of the button
	scale = HOVER_SCALE


func _on_mouse_exited() -> void:
	scale = DEFAULT_SCALE
