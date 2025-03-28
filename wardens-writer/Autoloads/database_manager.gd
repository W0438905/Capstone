extends Node

var db: SQLite


func _ready() -> void:
	# Create database
	db = SQLite.new()
	db.path = "res://wk_db.db" # The file path. May need tweaking when root folder is moved
	db.foreign_keys = true # Allows foreign keys to be used
	db.open_db() # Path to db set above. If db exists, use it. If not, make new one
	
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
			FOREIGN KEY("storyId") REFERENCES "Stories"("storyId") ON UPDATE CASCADE ON DELETE CASCADE
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
			FOREIGN KEY("chapterId") REFERENCES "Chapters"("chapterId") ON UPDATE CASCADE ON DELETE CASCADE,
			FOREIGN KEY("storyId") REFERENCES "Stories"("storyId") ON UPDATE CASCADE ON DELETE CASCADE
		);
	"""
	
	# Drop each table (debug)
	#var result: bool = db.query("DROP TABLE IF EXISTS Notes; DROP TABLE IF EXISTS Chapters; DROP TABLE IF EXISTS Stories;")
	#if result:
		#print("Dropped tables.")
	#else:
		#print("Tables not found.")
	# #######################
	
	# Add each table to the database
	db.query(story_table)
	db.query(chapter_table)
	db.query(note_table)
