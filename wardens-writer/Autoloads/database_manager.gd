extends Node

var database: SQLite


func _ready() -> void:
	# Create database
	database = SQLite.new()
	database.path = "res://wk_db.db" # The file path. May need tweaking when root folder is moved
	database.foreign_keys = true # Allows foreign keys to be used
	database.open_db() # Path to db set above. If db exists, use it. If not, make new one
	
	# Create Stories table
	var story_table: String = """
		CREATE TABLE IF NOT EXISTS Stories (
			"storyId" INTEGER NOT NULL,
			"title" text NOT NULL,
			"author" text,
			"description" text,
			"createdAt" text NOT NULL,
			"updatedAt" text NOT NULL,
			PRIMARY KEY("storyId" AUTOINCREMENT)
		);
	"""
	
	# Create Chapters table
	var chapter_table: String = """
		CREATE TABLE IF NOT EXISTS Chapters (
			"chapterId" INTEGER NOT NULL,
			"storyId" INTEGER NOT NULL,
			"title" text NOT NULL,
			"description" text,
			"content" text,
			"chapterOrder" INTEGER NOT NULL,
			"createdAt" text NOT NULL,
			"updatedAt" text NOT NULL,
			PRIMARY KEY("chapterId" AUTOINCREMENT),
			FOREIGN KEY("storyId") REFERENCES "Stories"("storyId") ON DELETE CASCADE
		);
	"""
	
	# Create Notes table
	var note_table: String = """
		CREATE TABLE IF NOT EXISTS Notes (
			"noteId" INTEGER NOT NULL,
			"storyId" INTEGER NOT NULL,
			"chapterId" INTEGER,
			"noteType" INTEGER NOT NULL,
			"title" text NOT NULL,
			"content" text,
			"createdAt" text NOT NULL,
			"updatedAt" text NOT NULL,
			PRIMARY KEY("noteId" AUTOINCREMENT),
			FOREIGN KEY("chapterId") REFERENCES "Chapters"("chapterId") ON DELETE CASCADE,
			FOREIGN KEY("storyId") REFERENCES "Stories"("storyId") ON DELETE CASCADE
		);
	"""
	
	# Drop each table (debug)
	var result: bool = database.query("SELECT * FROM Stories; SELECT * FROM Chapters; SELECT * FROM Notes;")
	if result:
		database.drop_table("Notes")
		database.drop_table("Chapters")
		database.drop_table("Stories")
		print("Dropped tables.")
	else:
		print("Tables not found.")
	
	# Add each table to the database
	database.query(story_table)
	database.query(chapter_table)
	database.query(note_table)
	

# Scenes should call function(s) in db_manager to fill vars with queried data.
# Queried data should be sent from db_manager to requesting scene.
