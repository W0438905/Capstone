extends Node

var database: SQLite


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Create database
	database = SQLite.new()
	database.path = "res://wk_db.db" # The file path. May need tweaking when root folder is moved
	database.foreign_keys = true # Allows foreign keys to be used
	database.open_db() # Path to db set above. If db exists, use it. If not, make new one
	
	# Create Stories table
	var story_table = {
		"id": { "data_type": "int", "primary_key": true, "not_null": true, "auto_increment": true },
		"title": { "data_type": "text", "not_null": true },
		"author": { "data_type": "text" },
		"description": { "data_type": "text" },
		"createdAt": { "data_type": "text", "not_null": true },
		"updatedAt": { "data_type": "text", "not_null": true }
	}
	
	# Create Chapters table
	var chapter_table = {
		"id": { "data_type": "int", "primary_key": true, "not_null": true, "auto_increment": true },
		"storyId": { "data_type": "int", "foreign_key": "Stories.id", "not_null": true},
		"title": { "data_type": "text", "not_null": true },
		"description": { "data_type": "text" },
		"content": { "data_type": "text" },
		"chapterOrder": { "data_type": "int", "not_null": true },
		"createdAt": { "data_type": "text", "not_null": true },
		"updatedAt": { "data_type": "text", "not_null": true }
	}
	
	# Create Notes table
	var note_table = {
		"id": { "data_type": "int", "primary_key": true, "not_null": true, "auto_increment": true },
		"storyId": { "data_type": "int", "foreign_key": "Stories.id", "not_null": true},
		"chapterId": { "data_type": "int", "foreign_key": "Chapters.id" },
		"noteType": { "data_type": "int", "not_null": true },
		"title": { "data_type": "text", "not_null": true },
		"content": { "data_type": "text" },
		"createdAt": { "data_type": "text", "not_null": true },
		"updatedAt": { "data_type": "text", "not_null": true }
	}
	
	# Add each table to the database
	database.create_table("Stories", story_table)
	database.create_table("Chapters", chapter_table)
	database.create_table("Notes", note_table)
	


# Scenes should call function(s) in db_manager to fill vars with queried data.
# Queried data should be sent from db_manager to requesting scene.
