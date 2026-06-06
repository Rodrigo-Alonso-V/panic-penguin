extends Node

const SAVE_PATH = "user://gamedata.cfg"


func save_game(points):
	var config = ConfigFile.new()
	
	config.set_value("Progreso","points_record",points)
	config.save(SAVE_PATH)


func load_game():
	var config = ConfigFile.new()
	config.load(SAVE_PATH)
	return config.get_value("Progreso","points_record",0)
